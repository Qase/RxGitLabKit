//
//  CommitsViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxGitLabKit
import RxSwift
import RxCocoa

class CommitsViewModel: BaseViewModel {
  
  // MARK: Private properties
  private let commits: Variable<[Commit]>
  private let paginator: Paginator<Commit>!
  private var pagesLoaded = 0
  private let loadNextPageTrigger = PublishSubject<Void>()

  
  // MARK: Outputs
  let gitlabClient: RxGitLabAPIClient!
  let projectID: Int

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
    loadNextProjectPage()
  }
  
  private func setupBindings() {
    loadNextPageTrigger
      .flatMap {
        return self.paginator[self.pagesLoaded]
      }
      .subscribe(onNext: { commits in
        self.commits.value.append(contentsOf: commits)
      })
      .disposed(by: disposeBag)
  }
  
  func commit(for index: Int) -> Commit {
    return commits.value[index]
  }
  
  func loadNextProjectPage() {
    pagesLoaded = pagesLoaded + 1
    loadNextPageTrigger.onNext(())
  }
  
}
