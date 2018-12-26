//
//  ProjectsViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxGitLabKit

class ProjectsViewModel: BaseViewModel {
  
  // MARK: Private properties
  private let projects = Variable<[Project]>([])
  private let model = ProjectsModel()
  private let projectsEndpointGroup: ProjectsEnpointGroup!
  private let loadNextProjectPageTrigger = PublishSubject<Void>()
  private let loadNextUserProjectPageTrigger = PublishSubject<Void>()
  
  // MARK: Public properties
  let gitlabClient: RxGitLabAPIClient!
  let isUserTabSelectedVariable = Variable<Bool>(false)
  let searchTextVariable = Variable<String?>("")
  let projectPaginator = Variable<Paginator<Project>?>(nil)
  var lastProjectPage = 0
  
  let userProjectPaginator = Variable<Paginator<Project>?>(nil)
  var lastUserProjectPage = 0
  
  let projectsPublisher = PublishSubject<[Project]>()
  
  let isLoadingPublisher = PublishSubject<Bool>()

  // MARK: Outputs
  var dataSource: Observable<[Project]> {
    return projectsPublisher.asObservable()
  }
  
  init(with gitlabClient: RxGitLabAPIClient, driver: Driver<Void>? = nil) {
    self.gitlabClient = gitlabClient
    self.projectsEndpointGroup = gitlabClient.projects
    super.init()
    setupBindings()
    self.projectPaginator.value = self.projectsEndpointGroup.getProjects(parameters: [
      "simple" : true,
      "sort" : "asc"
      ] as [String : Any])
  }
  
  private func setupBindings() {
    let searchTextObservable = searchTextVariable.asObservable()
    
    searchTextObservable.subscribe(onNext: { searchText in
      let parameters = [
        "search" : searchText ?? "",
        "simple" : true,
        "sort" : "asc"
        ] as [String : Any]
        self.model.userProjects.value = []
        self.model.projects.value = []
        if let user = self.gitlabClient.currentUserVariable.value {
          self.userProjectPaginator.value = self.projectsEndpointGroup.getUserProjects(userID: user.id, parameters: parameters)
        } else {
          self.userProjectPaginator.value = nil
        }
        self.projectPaginator.value = self.projectsEndpointGroup.getProjects(parameters: parameters)
      })
      .disposed(by: disposeBag)
    
    gitlabClient.currentUserObservable
      .filter { $0 != nil }
      .subscribe(onNext: { (user) in
        guard let user = user else { return }
        self.userProjectPaginator.value = self.projectsEndpointGroup.getUserProjects(userID: user.id, parameters: [
          "simple" : true,
          "sort" : "asc"
          ] as [String : Any])
      })
      .disposed(by: disposeBag)
    
    projectPaginator.asObservable()
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        self.lastProjectPage = 1
       return paginator[self.lastProjectPage]
      }
      .subscribe(onNext: { (projects) in
        self.model.projects.value = projects
      })
      .disposed(by: disposeBag)
    
    userProjectPaginator.asObservable()
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        self.lastUserProjectPage = 1
        return paginator[self.lastProjectPage]
      }
      .subscribe(onNext: { (projects) in
        self.model.userProjects.value = projects
      })
      .disposed(by: disposeBag)
    
    loadNextProjectPageTrigger
      .map { self.projectPaginator.value }
      .filter { $0 != nil}
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        return paginator[self.lastProjectPage]
      }
      .subscribe(onNext: { projects in
        self.model.projects.value.append(contentsOf: projects)
      })
      .disposed(by: disposeBag)
    
    loadNextUserProjectPageTrigger
      .map { self.userProjectPaginator.value }
      .filter { $0 != nil}
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        return paginator[self.lastUserProjectPage]
      }
      .subscribe(onNext: { projects in
        self.model.userProjects.value.append(contentsOf: projects)
      })
      .disposed(by: disposeBag)
    
    isUserTabSelectedVariable.asObservable()
      .subscribe(onNext: { (isUserTab) in
        if isUserTab {
          self.projectsPublisher.onNext( self.model.userProjects.value)
        } else {
          self.projectsPublisher.onNext( self.model.projects.value)
        }
      })
      .disposed(by: disposeBag)
    
    Observable.of(loadNextUserProjectPageTrigger.asObservable(), loadNextProjectPageTrigger.asObservable(), searchTextObservable.map{_ in ()})
      .merge()
      .debug()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.isLoadingPublisher.onNext(true)
      })
      .disposed(by: disposeBag)
    
    Observable.combineLatest(model.projects.asObservable(), model.userProjects.asObservable(), isUserTabSelectedVariable.asObservable())
      .subscribe (onNext: { projects, userProjects, isUser in
        self.projectsPublisher.onNext(isUser ? userProjects : projects)
        self.isLoadingPublisher.onNext(false)
      })
      .disposed(by: disposeBag)
  }
  
  func projectID(for index: Int) -> Project {
    
    return isUserTabSelectedVariable.value ? model.userProjects.value[index] :  model.projects.value[index]
  }
  
  func loadProjects(_ search: String? = nil) {
//    searchTextVariable.value = search
    loadNextProjectPageTrigger.onNext(())
  }
  
  func loadNextProjectPage() {
    lastProjectPage += 1
    loadNextProjectPageTrigger.onNext(())
  }
  
  func loadNextUserProjectPage() {
    lastUserProjectPage += 1
    loadNextUserProjectPageTrigger.onNext(())
  }
  
}
