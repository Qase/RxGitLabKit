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

/// Projects model handles all projects and user projects
class ProjectsViewModel: BaseViewModel {
  
  // MARK: Private properties
  private let projects = Variable<[Project]>([])
  private let model = ProjectsModel()
  private let projectsEndpointGroup: ProjectsEnpointGroup!
  
  // Load next Triggers
  private let loadNextProjectPageTrigger = PublishSubject<Void>()
  private let loadNextUserProjectPageTrigger = PublishSubject<Void>()
  
  /// Publishes loading state changes
  private let isLoadingPublisher = PublishSubject<Bool>()
  
  /// Notifies if projects are loading
  var isLoading: Observable<Bool> {
    return isLoadingPublisher.asObservable()
  }
  
  /// Projects pagination
  private let projectPaginator: Variable<Paginator<Project>>
  private var lastProjectPage = 0
  
  /// User projects pagination
  private let userProjectPaginator = Variable<Paginator<Project>?>(nil)
  private var lastUserProjectPage = 0
  
  /// Logged in user
  private let currentUserVariable = Variable<User?>(nil)
  
  
  // MARK: Public properties
  let gitlabClient: RxGitLabAPIClient
  let isUserTabSelectedVariable = Variable<Bool>(false)
  let searchTextVariable = Variable<String?>("")
  
  // MARK: Outputs
  // Publishing Projects out
  private let projectsPublisher = PublishSubject<[Project]>()
  var dataSource: Observable<[Project]> {
    return projectsPublisher.asObservable()
  }
  
  init(with gitlabClient: RxGitLabAPIClient, driver: Driver<Void>? = nil) {
    self.gitlabClient = gitlabClient
    self.projectsEndpointGroup = gitlabClient.projects
    
    self.projectPaginator = Variable<Paginator<Project>>(self.projectsEndpointGroup.getProjects(parameters: [
      "simple" : true,
      "sort" : "asc"
      ] as [String : Any]))
    super.init()
    setupBindings()
  }
  
  private func setupBindings() {
    
    // Logged in User binding
    gitlabClient
      .currentUserObservable
      .bind(to: currentUserVariable)
      .disposed(by: disposeBag)
    
    // User Projects Paginator
    currentUserVariable.asObservable()
      .subscribe(onNext: { (user) in
        guard let user = user else {
          self.userProjectPaginator.value = nil
          return }
        self.userProjectPaginator.value = self.projectsEndpointGroup.getUserProjects(userID: user.id, parameters: [
          "simple" : true,
          "sort" : "asc"
          ] as [String : Any])
      })
      .disposed(by: disposeBag)
    
    
    // Text search
    let searchTextObservable = searchTextVariable.asObservable()
      .throttle(0.2, scheduler: MainScheduler.instance)
      .share()
    
    // Creating Project Paginator and User paginator from search text
    searchTextObservable.subscribe(onNext: { searchText in
      let parameters = [
        "search" : searchText ?? "",
        "simple" : true,
        "sort" : "asc"
        ] as [String : Any]
      self.model.userProjects.value = []
      self.model.projects.value = []
      if let user = self.currentUserVariable.value {
        self.userProjectPaginator.value = self.projectsEndpointGroup.getUserProjects(userID: user.id, parameters: parameters)
      }
      
      self.projectPaginator.value = self.projectsEndpointGroup.getProjects(parameters: parameters)
    })
      .disposed(by: disposeBag)
    
    // Load projects when a new paginator is set
    projectPaginator.asObservable()
      .do(onNext: { _ in
        self.lastProjectPage = 1
        self.isLoadingPublisher.onNext(true)
      })
      .flatMap { (paginator) -> Observable<[Project]> in
        return paginator[self.lastProjectPage]
      }
      .subscribe(onNext: { (projects) in
        self.model.projects.value = projects
      })
      .disposed(by: disposeBag)
    
    // Load user projects when a new paginator is set
    userProjectPaginator.asObservable()
      .do(onNext: { _ in
        self.lastUserProjectPage = 1
      })
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        return paginator[self.lastProjectPage].debug()
      }
      .subscribe(onNext: { (projects) in
        self.model.userProjects.value = projects
      })
      .disposed(by: disposeBag)
    
    // Load next project page using the latest paginator
    loadNextProjectPageTrigger
      .map { self.projectPaginator.value }
      .flatMap { (paginator) -> Observable<[Project]> in
        return paginator[self.lastProjectPage]
      }
      .subscribe(onNext: { projects in
        self.model.projects.value.append(contentsOf: projects)
      })
      .disposed(by: disposeBag)
    
    // Load next user project page using the latest paginator
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
    
    // Changes the data source when a different tab is selected
    isUserTabSelectedVariable.asObservable()
      .subscribe(onNext: { (isUserTab) in
        if isUserTab {
          self.projectsPublisher.onNext( self.model.userProjects.value)
        } else {
          self.projectsPublisher.onNext( self.model.projects.value)
        }
      })
      .disposed(by: disposeBag)
    
    // Publish that the projects are loading
    Observable.of(loadNextUserProjectPageTrigger.asObservable().debug(),
                  loadNextProjectPageTrigger.asObservable().debug(),
                  searchTextObservable.map{_ in ()}.skip(1).debug())
      .merge()
      .debug()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.isLoadingPublisher.onNext(true)
      })
      .disposed(by: disposeBag)
    
    // Publish that the loading has stopped
    Observable.combineLatest(model.projects.asObservable(), model.userProjects.asObservable(), isUserTabSelectedVariable.asObservable())
      .subscribe (onNext: { projects, userProjects, isUser in
        self.projectsPublisher.onNext(isUser ? userProjects : projects)
        self.isLoadingPublisher.onNext(false)
      })
      .disposed(by: disposeBag)
  }
  
  // Returns a projectID
  func projectID(for index: Int) -> Project {
    return isUserTabSelectedVariable.value ? model.userProjects.value[index] :  model.projects.value[index]
  }
  
  // Load next projects page trigger
  func loadNextProjectPage() {
    lastProjectPage += 1
    loadNextProjectPageTrigger.onNext(())
  }
  
  // Load next user project page trigger
  func loadNextUserProjectPage() {
    if userProjectPaginator.value != nil {
      lastUserProjectPage += 1
      loadNextUserProjectPageTrigger.onNext(())
    }
  }
}
