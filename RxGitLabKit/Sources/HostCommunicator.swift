//
//  HostCommunicator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation
import RxSwift

public class HostCommunicator {
  public let network: Networking
  public var hostURL: URL
  public var privateToken: String? = nil
  public let oAuthTokenVariable = Variable<String?>(nil)
  public let disposeBag = DisposeBag()
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

  public init(network: Networking, hostURL: URL) {
    self.network = network
    self.hostURL = hostURL
  }
  
  public convenience init(hostURL: URL) {
    self.init(network: HTTPClient(using: URLSession.shared), hostURL: hostURL)
  }

  public func header(for apiRequest: APIRequesting) -> Observable<Header> {
     guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.header(for: request)
  }

  public func object<T>(for apiRequest: APIRequesting, apiVersion: String? = RxGitLabAPIClient.apiVersionURLString) -> Observable<T> where T: Codable {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader, apiVersion: apiVersion) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }

  public func data(for apiRequest: APIRequesting) -> Observable<Data> {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.data(for: request)
  }

  public func response(for apiRequest: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.response(for: request)
  }

  public func httpURLResponse(for apiRequest: APIRequesting) -> Observable<HTTPURLResponse> {
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in
        return response
      }
  }

}
