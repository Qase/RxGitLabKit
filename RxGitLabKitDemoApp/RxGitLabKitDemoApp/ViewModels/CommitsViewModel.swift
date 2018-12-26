//
//  CommitsViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxGitLabKit
import RxCocoa

class CommitsViewModel: BaseViewModel {
  
  // MARK: Private properties
  private let commits: Variable<[Commit]>
  private let paginator: Paginator<Commit>!
  private var pagesLoaded = 0
  
  /// Loading trigger
  private let loadNextPageTrigger = PublishSubject<Void>()
  
  /// isLoading trigger
  private let isLoadingPublisher = PublishSubject<Bool>()
  

  
  // MARK: Outputs
  let gitlabClient: RxGitLabAPIClient!
  let projectID: Int
  
  /// isLoading
  var isLoading: Observable<Bool> {
    return isLoadingPublisher.asObservable()
  }
  
  /// Data Source
  var dataSource: Observable<[Commit]> {
    return commits.asObservable()
  }
  
  init(with gitlabClient: RxGitLabAPIClient, projectID: Int) {
    self.gitlabClient = gitlabClient
    self.projectID = projectID
    commits = Variable<[Commit]>([])
    paginator = self.gitlabClient.commits.getCommits(projectID: projectID)
    super.init()
    setupBindings()
  }
  
  private func setupBindings() {
    loadNextPageTrigger
      .do(onNext: { _ in self.isLoadingPublisher.onNext(true) })
      .flatMap {
        return self.paginator[self.pagesLoaded]
      }
      .debug()
      .subscribe(onNext: { commits in
        self.commits.value.append(contentsOf: commits)
        self.isLoadingPublisher.onNext(false)
      })
      .disposed(by: disposeBag)
  }
  
  /// Returns a commit for a given index
  func commit(for index: Int) -> Commit {
    return commits.value[index]
  }
  
  /// Triggers next page loading
  func loadNextProjectPage() {
    pagesLoaded += 1
    loadNextPageTrigger.onNext(())
  }
  
}
