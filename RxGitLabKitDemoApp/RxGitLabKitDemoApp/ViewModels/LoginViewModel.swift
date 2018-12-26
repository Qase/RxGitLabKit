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
  
  private let userVariable = Variable<User?>(nil)
  
  let gitlabClient: RxGitLabAPIClient
  
  /// User Observable
  var user: Observable<User?> {
    return userVariable.asObservable()
      .skip(1) // Skips the first nil
      .debug()
  }
  
  init(using gitlabClient: RxGitLabAPIClient) {
    self.gitlabClient = gitlabClient
    super.init()
    gitlabClient.currentUserObservable
      .bind(to: userVariable)
      .disposed(by: disposeBag)
  }
  
  /// Logs in using one of the methods
  ///
  /// If more tokens are provided, the priority of the methods
  /// are in this order (from highest to lowest):
  ///   1. Private Token
  ///   2. OAuth Token
  ///   3. username and password
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
  
  // MARK: Private functions
  
  /// Login using `username` and `password`
  private func logIn(username: String, password: String) {
    gitlabClient.logIn(username: username, password: password)
  }
  
  /// Login using private token
  private func logIn(privateToken: String) {
    gitlabClient.logIn(privateToken: privateToken)
  }
  
  /// Login using OAuth token
  private func logIn(oAuthToken: String) {
    gitlabClient.logIn(oAuthToken: oAuthToken)
  }
  
  /// Change host url
  private func changeHostURL(hostURL: URL) {
    gitlabClient.changeHostURL(hostURL: hostURL)
  }
  
  /// Creates an URL from text. Returns `nil` if it fails.
  private func urlFromText(urlString: String) -> URL? {
    var newURL: URL? = URL(string: urlString)
    if !(urlString.contains("http://") || urlString.contains("https://")) {
      newURL = URL(string: "https://\(urlString)")
    }
    return newURL
  }
}
