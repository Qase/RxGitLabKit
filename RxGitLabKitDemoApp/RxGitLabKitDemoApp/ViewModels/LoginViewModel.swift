//
//  LoginViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxGitLabKit

class LoginViewModel: BaseViewModel {

  let gitlabClient: RxGitLabAPIClient
  private let userVariable = Variable<User?>(nil)
  
  var user: Observable<User> {
    return userVariable.asObservable()
      .filter { $0 != nil }
      .map { $0! }
      .debug()
  }
  
  init(using gitlabClient: RxGitLabAPIClient) {
    self.gitlabClient = gitlabClient
    super.init()
    gitlabClient.currentUserObservable
    .bind(to: userVariable)
    .disposed(by: disposeBag)
  }
  
  func login(fields: [String: String]) {
    if let hostURL = fields["hostURL"], let newURL = urlFromText(urlString: hostURL),  newURL != gitlabClient.hostURL {
      changeHostURL(hostURL: newURL)
    }
    
    if let privateToken = fields["privateToken"] {
      logIn(privateToken: privateToken)
    } else if let oAuthToken = fields["oAuthToken"] {
      logIn(oAuthToken: oAuthToken)
    } else if let username = fields["username"], let password = fields["password"] {
      logIn(username: username, password: password)
    }
  }

  private func logIn(username: String, password: String) {
    gitlabClient.logIn(username: username, password: password)
  }
  
  private func logIn(privateToken: String) {
    gitlabClient.logIn(privateToken: privateToken)
  }
  
  private func logIn(oAuthToken: String) {
    gitlabClient.logIn(oAuthToken: oAuthToken)
  }
  
  private func changeHostURL(hostURL: URL) {
    gitlabClient.changeHostURL(hostURL: hostURL)
  }
  
  private func urlFromText(urlString: String) -> URL? {
    var newURL: URL? = URL(string: urlString)
    if !(urlString.contains("http://") || urlString.contains("https://")) {
      newURL = URL(string: "https://\(urlString)")
    }
    return newURL
  }
}
