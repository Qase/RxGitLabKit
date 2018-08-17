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
  var hostURL: URL { get set }
//  var privateToken: String { get set }
//
//  func authenticate(host: URL)
//
//  func authenticate(host: URL, privateToken: String)
//
//  func authenticate(host: URL, OAuthToken: String)
//
//  func authenticate(host: URL, email: String, password: String)
//
  
  //func object<T>(request: APIRequesting) -> Observable<T> where T : Decodable, T : Encodable
}


//extension RxGitLabAPIClienting {
//  let privateTokenKey = "private_token"
//
//}

class RxGitLabAPIClient: RxGitLabAPIClienting {
  
  public weak var shared: RxGitLabAPIClient! {
    get {
//      if shared == nil {
//        shared = RxGitLabAPIClient()
//      }
      return self.shared
    }
  }
  
  public var privateToken = BehaviorSubject<String?>(value: nil)
  
  public var oAuthToken =  BehaviorSubject<String?>(value: nil)
  
  public var email = BehaviorSubject<String?>(value: nil)

  public var password = BehaviorSubject<String?>(value: nil)
  
  var hostURL: URL
  
  private let network: Networking = {
    return Network(with: URLSession.shared)
  }()
  
  
  // MARK: Endpoints
  
  lazy var commits: CommitsEndpoint = {
    return createAndSubscribeEndpoint(class: CommitsEndpoint.self)
    let endpoint = CommitsEndpoint(network: network, hostURL: hostURL)
    subscribeToTokens(endpoint: endpoint)
    return endpoint
  }()
  
  lazy var repositories: RepositoriesEndpoint = {
    let endpoint = RepositoriesEndpoint(network: network, hostURL: hostURL)
    subscribeToTokens(endpoint: endpoint)
    return endpoint
  }()
  
  private func subscribeToTokens(endpoint: Endpoint) {
    oAuthToken.filter { $0 != nil}
      .subscribe(onNext: { token in
        endpoint.oAuthToken.value = token
      }).disposed(by: endpoint.disposeBag)
    
    privateToken.filter { $0 != nil}
      .subscribe(onNext: { token in
        endpoint.oAuthToken.value = token
      }).disposed(by: endpoint.disposeBag)
  }
  
  private func createAndSubscribeEndpoint<T: Endpoint>(class: T) -> T {
    let endpoint = T(network: network, hostURL: hostURL)
    subscribeToTokens(endpoint: endpoint)
    return endpoint
  }
  
  init(with hostURL: URL) {
    self.hostURL = hostURL
  }
  
  convenience init?(hostURL: URL, privateToken: String) {
    self.init(with: hostURL)
    self.privateToken.onNext(privateToken)
//    self.init(hostURL: hostURL)
//    self.privateToken = privateToken
//    self.commits = CommitsEndpoint(network: network)
    
  }
  
  convenience init?(hostURL: URL, oAuthToken: String) {
    self.init(with: hostURL)
    self.oAuthToken.onNext(oAuthToken)
    //    self.init(hostURL: hostURL)
    //    self.privateToken = privateToken
    //    self.commits = CommitsEndpoint(network: network)
    
  }
  
//  func authenticate() -> Observable<APIResponse> {
//
//
//  }
  
  
}
