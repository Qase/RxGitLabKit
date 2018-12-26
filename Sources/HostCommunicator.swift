//
//  HostCommunicator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation
import RxSwift

/// Facilitates the communication between the client and server
///
/// For authenticated communication, it uses a Private or OAuth token
public class HostCommunicator {
  
  /// Networking
  private let network: Networking
  private let disposeBag = DisposeBag()
  
  /// Returns an authorization header based on provided token
  private var authorizationHeader: Header {
    var header = Header()
    if let privateToken = privateToken {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthTokenVariable.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
    return header
  }
  
  /// The URL of the GitLab Host
  public var hostURL: URL
  
  /// Private token used for authorized communication
  public var privateToken: String? = nil
  
  /// OAuth token used for authorized communication
  public let oAuthTokenVariable = Variable<String?>(nil)
  
  public init(network: Networking, hostURL: URL) {
    self.network = network
    self.hostURL = hostURL
  }
  
  public convenience init(hostURL: URL) {
    self.init(network: HTTPClient(using: URLSession.shared), hostURL: hostURL)
  }
  
  /// Header from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<Header>
  public func header(for apiRequest: APIRequest) -> Observable<Header> {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.header(for: request)
  }
  
  /// Object of type T from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<T>
  public func object<T>(for apiRequest: APIRequest) -> Observable<T> where T: Codable {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }
  
  /// Data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<Data>
  public func data(for apiRequest: APIRequest) -> Observable<Data> {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.data(for: request)
  }
  
  /// A server response with data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<(response: HTTPURLResponse, data: Data?)>
  public func response(for apiRequest: APIRequest) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.response(for: request)
  }
  
  /// A server response without data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<HTTPURLResponse>
  public func httpURLResponse(for apiRequest: APIRequest) -> Observable<HTTPURLResponse> {
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in
        return response
    }
  }
}
