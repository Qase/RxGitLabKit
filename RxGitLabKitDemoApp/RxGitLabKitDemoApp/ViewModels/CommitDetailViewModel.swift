//
//  CommitDetailViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxGitLabKit
import RxSwift

class CommitDetailViewModel: BaseViewModel {
  
  private let commitVariable: Variable<Commit>
  
  /// Data for the table
  var dataSource: Observable<[(String, String)]> {
    return commitVariable.asObservable()
      .map { (commit) -> [(String, String)] in
        var texts = [(String,String)]()
        texts.append(("ID", commit.id))
        texts.append(("Short ID", commit.shortId))
        
        if let title = commit.title {
          texts.append(("Title", title))
        }
        texts.append(("Author name", commit.authorName))
        
        if let authorEmail = commit.authorEmail {
          texts.append(("Author e-mail", authorEmail))
        }
        if let authoredDate = commit.authoredDate?.localizedString {
          texts.append(("Authored date", authoredDate))
        }
        
        texts.append(("Committer name", commit.committerName))
        
        texts.append(("Committer e-mail", commit.committerEmail))
        
        if let committedDate = commit.committedDate?.localizedString {
          texts.append(("Committed date", committedDate))
        }
        if let createdAt = commit.createdAt?.localizedString {
          texts.append(("Created at", createdAt))
        }
        if let message = commit.message {
          texts.append(("Message", message))
        }
        if let parentIds = commit.parentIds?.joined(separator: ",") {
          texts.append(("Parent IDs", parentIds))
        }
        if let stats = commit.stats {
          if let total = stats.total {
            texts.append(("Total", String(total)))
          }
          
          if let additions = stats.additions {
            texts.append(("Additions", String(additions)))
          }
          
          if let deletions = stats.deletions {
            texts.append(("Deletions", String(deletions)))
          }
        }
        
        if let status = commit.status {
          texts.append(("Status", status))
        }
        return texts
    }
  }
  
  init(with gitlabClient: RxGitLabAPIClient, commit: Commit, projectID: Int) {
    commitVariable = Variable<Commit>(commit)
    super.init()
    // load additional commit data
    gitlabClient.commits
      .getCommit(projectID: projectID, sha: commit.id)
      .bind(to: commitVariable)
      .disposed(by: disposeBag)
  }
}
