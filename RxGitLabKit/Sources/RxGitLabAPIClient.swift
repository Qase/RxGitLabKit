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
  
  public var hostURL: URL
  
  public var urlSession = URLSession.shared
  
  public var privateToken = Variable<String?>(nil)
  
  public var oAuthToken =  Variable<String?>(nil)
  
  public var perPage = Variable<Int>(RxGitLabAPIClient.defaultPerPage)

  
  public let network: Networking!
  
  public static let defaultPerPage = 20
  
  public static var apiVersion = 4
  
  public static var apiVersionURLString: String {
    return "/api/v\(apiVersion)"
  }
  
  // MARK: Endpoint Groups
  
  public lazy var authentication: AuthenticationEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()
  
  public lazy var commits: CommitsEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()
  
  public lazy var projects: ProjectsEnpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()
  
  public lazy var repositories: RepositoriesEndpointGropu = {
    return createAndSubscribeEndpointGroup()
  }()
  
  public lazy var users: UsersEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()
  
  
  private func createAndSubscribeEndpointGroup<T: EndpointGroup>() -> T {
    let endpoint = T(network: network, hostURL: hostURL)
    oAuthToken.asObservable()
      .filter { $0 != nil}
      .bind(to: endpoint.oAuthToken)
      .disposed(by: endpoint.disposeBag)
    
    privateToken.asObservable()
      .filter { $0 != nil}
      .bind(to: endpoint.privateToken)
      .disposed(by: endpoint.disposeBag)
    
    perPage.asObservable()
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
    self.privateToken.value = privateToken
  }
  
  public convenience init(with hostURL: URL, oAuthToken: String, using session: URLSession = URLSession.shared) {
    self.init(with: hostURL, using: session)
    self.oAuthToken.value = oAuthToken
  }
  
  public func getOAuthToken(username: String, password: String) -> Observable<Authentication> {
    return authentication.authenticate(username: username, password: password)
  }
  
}
