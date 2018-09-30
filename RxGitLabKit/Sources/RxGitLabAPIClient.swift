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

public class RxGitLabAPIClient: RxGitLabAPIClienting {
    
  public var privateToken = BehaviorSubject<String?>(value: nil)
  
  public var oAuthToken =  BehaviorSubject<String?>(value: nil)
  
  public var perPage = BehaviorSubject<Int>(value: 100)
  
  public var hostURL: URL
  
  public var urlSession = URLSession.shared
  
  public let network: Networking!
  
  public static let defaultPerPage = 20
  
  public static var apiVersion = 4
  
  public static var apiVersionURLString: String {
    return "/api/v\(apiVersion)"
  }
  
  // MARK: Endpoints
  
  public lazy var authentication: AuthenticationEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  public lazy var commits: CommitsEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  public lazy var projects: ProjectsEnpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  public lazy var repositories: RepositoriesEndpoint = {
    return createAndSubscribeEndpoint()
  }()
  
  public lazy var users: UsersEndpoint = {
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
    
    perPage
      .filter { $0 > 0}
      .bind(to: endpoint.perPage)
      .disposed(by: endpoint.disposeBag)
    return endpoint
  }
  
  // MARK: Init
  public init(with hostURL: URL, using session: URLSession = URLSession.shared) {
    self.hostURL = hostURL
    self.network = Network(with: session)
  }
  
  public convenience init(with hostURL: URL, privateToken: String, using session: URLSession = URLSession.shared) {
    self.init(with: hostURL, using: session)
    self.privateToken.onNext(privateToken)
  }
  
  public convenience init(with hostURL: URL, oAuthToken: String, using session: URLSession = URLSession.shared) {
    self.init(with: hostURL, using: session)
    self.oAuthToken.onNext(oAuthToken)
  }
  
  public func getOAuthToken(username: String, password: String) -> Observable<Authentication> {
    return authentication.authenticate(username: username, password: password)
  }
  
}
