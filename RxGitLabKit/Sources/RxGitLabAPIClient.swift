//
//  RxGitLabAPIClient.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

public class RxGitLabAPIClient {

  public static let defaultPerPage = 20

  public static let apiVersion: Int = 4
  
  private let hostCommunicator: HostCommunicator
  
  public var privateToken: String? = nil
  
  public let oAuthTokenVariable = Variable<String?>(nil)
  
  private let disposeBag = DisposeBag()

  public static var apiVersionURLString: String {
    return "/api/v\(RxGitLabAPIClient.apiVersion)"
  }

  public var apiURLString: String {
    return "\(hostCommunicator.hostURL.absoluteString)\(RxGitLabAPIClient.apiVersionURLString)"
  }

  public let perPage = Variable<Int>(RxGitLabAPIClient.defaultPerPage)

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

  public lazy var repositories: RepositoriesEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()

  public lazy var users: UsersEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()

  // MARK: Init
  
  public init(with hostCommunicator: HostCommunicator) {
    self.hostCommunicator = hostCommunicator
    oAuthTokenVariable.asObservable()
      .bind(to: hostCommunicator.oAuthTokenVariable)
    .disposed(by: disposeBag)
  }

  public convenience init(with hostURL: URL) {
    self.init(with: HostCommunicator(network: HTTPClient(using: URLSession.shared), hostURL: hostURL))
  }

  public convenience init(with hostURL: URL, privateToken: String, using network: Networking? = nil) {
    let hostCommunicator = HostCommunicator(network: network ?? HTTPClient(using: URLSession.shared), hostURL: hostURL)
    hostCommunicator.privateToken = privateToken
    self.init(with: hostCommunicator)
  }

  public convenience init(with hostURL: URL, oAuthToken: String, using network: Networking? = nil) {
    let hostCommunicator = HostCommunicator(network: network ?? HTTPClient(using: URLSession.shared), hostURL: hostURL)
    hostCommunicator.oAuthTokenVariable.value = oAuthToken
    self.init(with: hostCommunicator)
  }

  // MARK: Private functions

  private func createAndSubscribeEndpointGroup<T: EndpointGroup>() -> T {
    let endpoint = T(with: hostCommunicator)
//    oAuthTokenVariable.asObservable()
//      .filter { $0 != nil}
//      .bind(to: endpoint.oAuthTokenVariable)
//      .disposed(by: endpoint.disposeBag)
//
//    privateTokenVariable.asObservable()
//      .filter { $0 != nil}
//      .bind(to: endpoint.privateTokenVariable)
//      .disposed(by: endpoint.disposeBag)
//
    perPage.asObservable()
      .filter { $0 > 0}
      .bind(to: endpoint.perPage)
      .disposed(by: endpoint.disposeBag)

    return endpoint
  }

  // MARK: Public Functions

  public func getOAuthToken(username: String, password: String) -> Observable<Authentication> {
    return authentication.authenticate(username: username, password: password)
  }

  public func login(username: String, password: String) -> Observable<Bool> {
    let tokenObservable = getOAuthToken(username: username, password: password)
      .map { $0.oAuthToken }
    tokenObservable.bind(to: oAuthTokenVariable)
      .disposed(by: disposeBag)
    return tokenObservable.map { $0 != nil }
  }

}
