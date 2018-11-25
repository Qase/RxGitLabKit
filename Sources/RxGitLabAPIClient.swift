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
  
  private let loginPublishSubject = PublishSubject<(String, String)>()
  private let getCurrentUserTrigger = PublishSubject<Void>()

  public let currentUserVariable = Variable<User?>(nil)
  
  public var currentUserObservable: Observable<User?> {
    return currentUserVariable.asObservable().distinctUntilChanged { $0?.id == $1?.id }
  }
  
  public static let defaultPerPage = 20

  public static let apiVersion: Int = 4
  
  public var hostURL: URL {
    return hostCommunicator.hostURL
  }
  
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

  public lazy var projects: ProjectsEnpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()

  public lazy var repositories: RepositoriesEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()
  
  public lazy var commits: CommitsEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()

  public lazy var users: UsersEndpointGroup = {
    return createAndSubscribeEndpointGroup()
  }()

  // MARK: Init
  
  public init(with hostCommunicator: HostCommunicator) {
    self.hostCommunicator = hostCommunicator
    setupBindings()
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
  
  private func setupBindings() {
    
    oAuthTokenVariable.asObservable()
      .bind(to: hostCommunicator.oAuthTokenVariable)
      .disposed(by: disposeBag)
    
    let tokenObservable = loginPublishSubject.flatMap { (arg0) -> Observable<String?> in
      let (username, password) = arg0
      return self.authentication.authenticate(username: username, password: password)
          .map { $0.oAuthToken }
      }
      .share()


    tokenObservable.bind(to: oAuthTokenVariable)
      .disposed(by: disposeBag)
    tokenObservable.bind(to: hostCommunicator.oAuthTokenVariable)
      .disposed(by: disposeBag)
    
    oAuthTokenVariable.asObservable()
      .filter { $0 != nil }
      .flatMap { _ in self.users.getCurrentUser() }
      .bind(to: currentUserVariable)
      .disposed(by: disposeBag)
    
    getCurrentUserTrigger.flatMap { self.users.getCurrentUser() }
      .debug()
      .bind(to: currentUserVariable)
      .disposed(by: disposeBag)
  }

  private func createAndSubscribeEndpointGroup<T: EndpointGroup>() -> T {
    let endpoint = T(with: hostCommunicator)
    perPage.asObservable()
      .filter { $0 > 0}
      .bind(to: endpoint.perPage)
      .disposed(by: endpoint.disposeBag)

    return endpoint
  }

  // MARK: Public Functions
  
  public func changeHostURL(hostURL: URL) {
    hostCommunicator.hostURL = hostURL
  }

  public func logIn(username: String, password: String){
    loginPublishSubject.onNext((username, password))
  }
  
  public func logIn(privateToken: String) {
    self.privateToken = privateToken
    hostCommunicator.privateToken = privateToken
    getCurrentUserTrigger.onNext(())
  }
  
  public func logIn(oAuthToken: String) {
    self.oAuthTokenVariable.value = oAuthToken
    getCurrentUserTrigger.onNext(())
  }
  
  public func logOut() {
    oAuthTokenVariable.value = nil
    privateToken = nil
    hostCommunicator.privateToken = nil
    currentUserVariable.value = nil
  }

}
