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
  
  public var privateToken = BehaviorSubject<String?>(value: nil)
  
  public var oAuthToken =  BehaviorSubject<String?>(value: nil)
  
  var hostURL: URL
  
  private let network: Networking = {
    return Network(with: URLSession.shared)
  }()
  
  // MARK: Endpoints
  
  lazy var commits: CommitsEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  lazy var repositories: RepositoriesEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  lazy var authentication: AuthenticationEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  private func createAndSubscribeEndpoint<T: Endpoint>() -> T {
    let endpoint = T(network: network, hostURL: hostURL)
    oAuthToken
      .filter { $0 != nil}
      .bind(to: endpoint.oAuthToken)
      .disposed(by: endpoint.disposeBag)
    
    privateToken
      .filter { $0 != nil}
      .bind(to: endpoint.privateToken)
      .disposed(by: endpoint.disposeBag)
    return endpoint
  }
  
  // MARK: Init
  init(with hostURL: URL) {
    self.hostURL = hostURL
  }
  
  convenience init?(hostURL: URL, privateToken: String) {
    self.init(with: hostURL)
    self.privateToken.onNext(privateToken)
  }
  
  convenience init?(hostURL: URL, oAuthToken: String) {
    self.init(with: hostURL)
    self.oAuthToken.onNext(oAuthToken)
  }
  
  func getOAuthToken(username: String, password: String) -> Observable<Authentication> {
    return authentication.authenticate(username: username, password: password)
  }
  
}
