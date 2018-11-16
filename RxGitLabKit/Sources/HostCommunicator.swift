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
  public let hostURL: URL
  public let privateTokenVariable = Variable<String?>(nil)
  public let oAuthTokenVariable = Variable<String?>(nil)
  public let disposeBag = DisposeBag()
  private var authorizationHeader: Header {
    var header = Header()
    if let privateToken = privateTokenVariable.value {
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
  
  public func header(for request: APIRequesting) -> Observable<Header> {
     guard let request = request.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.header(for: request)
  }
  
  public func object<T>(for request: APIRequesting) -> Observable<T> where T : Codable {
    guard let request = request.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }
  
  public func data(for request: APIRequesting) -> Observable<Data> {
    guard let request = request.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.data(for: request)
  }
  
  public func response(for request: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    guard let request = request.buildRequest(with: self.hostURL, header: authorizationHeader) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.response(for: request)
  }
  
  public func httpURLResponse(for request: APIRequesting) -> Observable<HTTPURLResponse> {
    return response(for: request)
      .map { (response, _) -> HTTPURLResponse in
        return response
      }
  }
  
  
}

