//
//  RxGitLabAPIClient.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

public class RxGitLabAPIClient: HostCommunicator {
  
  public static let defaultPerPage = 20
  
  public static var apiVersion = 4
  
  public static var apiVersionURLString: String {
    return "/api/v\(apiVersion)"
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
  
  public init(with hostURL: URL, using network: Networking) {
    super.init(network: network, hostURL: hostURL)
  }
  
  public convenience init(with hostURL: URL) {
    self.init(with: hostURL,using: HTTPClient(using: URLSession.shared))
  }
  
  public convenience init(with hostURL: URL, privateToken: String, using network: Networking? = nil) {
    self.init(with: hostURL, using: network ?? HTTPClient(using: URLSession.shared))
    self.privateTokenVariable.value = privateToken
  }
  
  public convenience init(with hostURL: URL, oAuthToken: String, using network: Networking? = nil) {
    self.init(with: hostURL, using: network ?? HTTPClient(using: URLSession.shared))
    self.oAuthTokenVariable.value = oAuthToken
  }
  
  // MARK: Private functions
  
  private func createAndSubscribeEndpointGroup<T: EndpointGroup>() -> T {
    let endpoint = T(network: network, hostURL: hostURL)
    oAuthTokenVariable.asObservable()
      .filter { $0 != nil}
      .bind(to: endpoint.oAuthTokenVariable)
      .disposed(by: endpoint.disposeBag)
    
    privateTokenVariable.asObservable()
      .filter { $0 != nil}
      .bind(to: endpoint.privateTokenVariable)
      .disposed(by: endpoint.disposeBag)
    
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
    return Observable.create { [weak self] observer in
      self?.authentication.authenticate(username: username, password: password)
        .take(1)
        .subscribe(onNext: { [weak self] token in
          self?.oAuthTokenVariable.value = token.oAuthToken
          observer.onNext(true)
          observer.onCompleted()
          }, onError: { error in
            observer.onError(error)
        })
        .disposed(by: self?.disposeBag ?? DisposeBag())
      return Disposables.create()
    }
  }
  
}
