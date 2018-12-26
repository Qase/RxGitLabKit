//
//  RxGitLabAPIClient.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

/// This class represents the main entry point to the RxGitLabKit library
///
/// This client is used for the communication with GitLabAPI.
public class RxGitLabAPIClient {
  
  private let disposeBag = DisposeBag()
  
  /// Login trigger
  private let loginPublishSubject = PublishSubject<(String, String)>()
  
  /// Fetching current user trigger
  private let getCurrentUserTrigger = PublishSubject<Void>()
  
  /// Logged in user variable
  public let currentUserVariable = Variable<User?>(nil)
  
  /// Observable of the current user
  public var currentUserObservable: Observable<User?> {
    return currentUserVariable.asObservable().distinctUntilChanged { $0?.id == $1?.id }.debug()
  }
  
  /// Default per page accoring to GitLab Docs
  public static let defaultPerPage = 20
  
  /// String representation of API v4 URI
  public static var apiVersionURLString: String {
    return "/api/v4"
  }
  
  /// GitLab Host URL
  public var hostURL: URL {
    return hostCommunicator.hostURL
  }
  
  /// The main communication component with GitLab API server
  internal let hostCommunicator: HostCommunicator
  
  /// Private Token
  public var privateToken: String? {
    get {
      return hostCommunicator.privateToken
    }
    set {
      hostCommunicator.privateToken = newValue
    }
  }
  
  /// OAuthToken
  public var oAuthToken: String? {
    get {
      return hostCommunicator.oAuthTokenVariable.value
    }
    set {
      hostCommunicator.oAuthTokenVariable.value = newValue
    }
  }

  // MARK: Endpoint Groups

  /// Endpoint group for Authentication
  public lazy var authentication: AuthenticationEndpointGroup = {
    return createEndpointGroup()
  }()

  /// Endpoint group for Projects
  public lazy var projects: ProjectsEnpointGroup = {
    return createEndpointGroup()
  }()

  /// Endpoint group for Repositories
  public lazy var repositories: RepositoriesEndpointGroup = {
    return createEndpointGroup()
  }()
  
  /// Endpoint group for Commits
  public lazy var commits: CommitsEndpointGroup = {
    return createEndpointGroup()
  }()

  /// Endpoint group for Users
  public lazy var users: UsersEndpointGroup = {
    return createEndpointGroup()
  }()

  /// Endpoint group for Members
  public lazy var members: MembersEndpointGroup = {
    return createEndpointGroup()
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
  
  /// Sets up login bindings
  private func setupBindings() {
    
   loginPublishSubject
    .flatMap { (arg0) -> Observable<String?> in
      let (username, password) = arg0
      return self.authentication.authenticate(username: username, password: password)
          .map { $0.oAuthToken }
      }
    .bind(to: hostCommunicator.oAuthTokenVariable)
    .disposed(by: disposeBag)
    
    hostCommunicator.oAuthTokenVariable.asObservable()
      .filter { $0 != nil }
      .flatMap { _ in self.users.getCurrentUser() }
      .distinctUntilChanged { $0?.id == $1?.id }
      .bind(to: currentUserVariable)
      .disposed(by: disposeBag)
    
    getCurrentUserTrigger
      .flatMap { self.users.getCurrentUser() }
      .bind(to: currentUserVariable)
      .disposed(by: disposeBag)
  }

  /// Factory method for creating an Endpoint Group instance
  private func createEndpointGroup<T: EndpointGroup>() -> T {
    return T(with: hostCommunicator)
  }

  // MARK: Public Functions
  
  
  /// Changes the GitLab Host URL
  ///
  /// - Parameter hostURL: The desired host URL
  public func changeHostURL(hostURL: URL) {
    hostCommunicator.hostURL = hostURL
  }

  
  /// Logs in a user using an username and password
  ///
  /// - Parameters:
  ///   - username: username or e-mail
  ///   - password: password
  public func logIn(username: String, password: String) {
    loginPublishSubject.onNext((username, password))
  }
  
  
  /// Sets the private token for communication with GitLab API server
  ///
  /// - Parameter privateToken: A private token
  public func logIn(privateToken: String) {
    self.privateToken = privateToken
    hostCommunicator.privateToken = privateToken
    getCurrentUserTrigger.onNext(())
  }
  
  /// Sets the OAuth token for communication with GitLab API server
  ///
  /// - Parameter privateToken: An OAuth token
  public func logIn(oAuthToken: String) {
    self.oAuthToken = oAuthToken
    getCurrentUserTrigger.onNext(())
  }
  
  /// Logs out the current user
  public func logOut() {
    oAuthToken = nil
    privateToken = nil
    currentUserVariable.value = nil
  }

}
