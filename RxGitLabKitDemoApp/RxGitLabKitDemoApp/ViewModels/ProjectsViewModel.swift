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
  private var pagesLoaded = 1
  private let projectsEndpointGroup: ProjectsEnpointGroup!
  private let loadNextPageTrigger = PublishSubject<Void>()
  
  
  // MARK: Public properties
  let gitlabClient: RxGitLabAPIClient!
  let isLoading = Variable<Bool>(true)
  var projectsCount: Int {
    return projects.value.count
  }
  
  var totalProjectsCount: Int {
    return 100
  }
  
  let isUserVariable = Variable<Bool>(false)
  
  let searchTextVariable = Variable<String?>(nil)
  
  var projectPaginator = Variable<Paginator<Project>?>(nil)

  // MARK: Outputs
  var dataSource: Observable<[Project]> {
    return projects.asObservable()
  }
  
  init(with gitlabClient: RxGitLabAPIClient, driver: Driver<Void>? = nil) {
    self.gitlabClient = gitlabClient
    self.projectsEndpointGroup = gitlabClient.projects
    super.init()
    setupBindings()
  }
  
  private func setupBindings() {
    Observable.combineLatest(searchTextVariable.asObservable(), isUserVariable.asObservable(), gitlabClient.currentUserObservable)
      .map { (arg) -> Paginator<Project>? in
        let (searchText, isUser, user) = arg
        let parameters = ["search" : searchText ?? ""]
       if isUser {
        if let user = user {
          return self.projectsEndpointGroup.getUserProjects(userID: user.id, parameters: parameters)
        } else {
          return nil
        }
       } else {
          return self.projectsEndpointGroup.getProjects(parameters: parameters)
        }
      }
      .bind(to: projectPaginator)
      .disposed(by: disposeBag)
    
    projectPaginator.asObservable()
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        self.pagesLoaded = 1
       return paginator[self.pagesLoaded]
      }
      .catchErrorJustReturn([])
      .bind(to: projects)
      .disposed(by: disposeBag)
    
    loadNextPageTrigger
      .flatMap { self.projectPaginator.asObservable() }
      .flatMap { (paginator) -> Observable<[Project]> in
        guard let paginator = paginator else { return Observable.just([]) }
        return paginator[self.pagesLoaded]
      }
      .subscribe(onNext: { projects in
        self.projects.value.append(contentsOf: projects)
      })
      .disposed(by: disposeBag)
    
  }
  
  func projectID(for index: Int) -> Project {
    return projects.value[index]
  }
  
  func loadProjects(_ search: String? = nil) {
    searchTextVariable.value = search
  }
  
  func loadNextProjectPage() {
    pagesLoaded = pagesLoaded + 1
    loadNextPageTrigger.onNext(())
  }
  
}
