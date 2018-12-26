//
//  SettingsViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxGitLabKit

class ProfileViewModel: BaseViewModel {
  let gitlabClient: RxGitLabAPIClient
  let user: User
  
  /// Data for table
  var dataSource: Observable<[(String, String)]> {
    return Observable.create { observer in
        var texts = [(String, String)]()
        
        texts.append(("ID", String(self.user.id)))
        if let state = self.user.state {
          texts.append(("State", state))
        }
        
        if let createdAt = self.user.createdAt {
          texts.append(("Created At", createdAt.asISO8601String))
        }
        if let oAuthToken = self.gitlabClient.oAuthToken {
          texts.append(("OAuth Token", oAuthToken))
        }
        
        if let privateToken = self.gitlabClient.privateToken {
          texts.append(("Private Token", privateToken))
        }
        observer.onNext(texts)
        observer.onCompleted()
      
      return Disposables.create()
    }
  }

  init(with gitlabClient: RxGitLabAPIClient, user: User) {
    self.gitlabClient = gitlabClient
    self.user = user
    super.init()
  }
  
  /// Logs out the current user
  func logOut() {
    gitlabClient.logOut()
  }
  
}
