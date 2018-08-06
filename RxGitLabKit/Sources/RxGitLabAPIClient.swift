//
//  RxGitLabAPIClient.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift

enum Endpoints {
  
}

public protocol RxGitLabAPIClienting {
  var host: String { get set }
  var privateToken: String { get set }
  
  func authenticate(host: URL)
  
  func authenticate(host: URL, privateToken: String)
  
  func authenticate(host: URL, OAuthToken: String)
  
  func authenticate(host: URL, email: String, password: String)
  
}


//extension RxGitLabAPIClienting {
//  let privateTokenKey = "private_token"
//
//}

class RxGitLabAPIClient {
  public weak var shared: RxGitLabAPIClient! {
    get {
//      if shared == nil {
//        shared = RxGitLabAPIClient()
//      }
      return self.shared
    }
  }
  
  public var host: URL = URL(string: "https://gitlab.com")!
  
  public var privateToken: String?
  
  public var OAuthToken: String?
  
  public var email: String?

  public var password: String?
  
  init(hostURL: URL) {
    self.host = hostURL
  }

  convenience init?(host: String, privateToken: String) {
    guard let hostURL = URL(string: host) else { return nil}
    self.init(hostURL: hostURL)
    self.privateToken = privateToken
  }
  
//  func authenticate() -> Observable<APIResponse> {
//
//
//  }
  
  
}
