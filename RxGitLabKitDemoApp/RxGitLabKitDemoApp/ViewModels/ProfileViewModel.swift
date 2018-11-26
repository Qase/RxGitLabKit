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
  let gitlabClient: RxGitLabAPIClient!
  let userVariable = Variable<User?>(nil)
  
  var user: User? {
    return userVariable.value
  }
  
  var dataSource: Observable<[(String, String)]> {
    return userVariable.asObservable()
      .filter { $0 != nil}
      .map { user in
        guard let user = user else { return [] }
        var texts = [(String, String)]()
        
        texts.append(("ID", String(user.id)))
        if let state = user.state {
          texts.append(("State", state))
        }
        
        if let createdAt = user.createdAt {
          texts.append(("Created At", createdAt.asISO8601String))
        }
        if let oAuthToken = self.gitlabClient.oAuthTokenVariable.value {
          texts.append(("OAuth Token", oAuthToken))
        }
        
        if let privateToken = self.gitlabClient.privateToken {
          texts.append(("OAuth Token", privateToken))
        }
        return texts
    }
  }

  init(with gitlabClient: RxGitLabAPIClient) {
    self.gitlabClient = gitlabClient
    super.init()
    gitlabClient.currentUserObservable
      .bind(to: userVariable)
      .disposed(by: self.disposeBag)
  }
  
  func logOut() {
    gitlabClient.logOut()
  }
  
}
