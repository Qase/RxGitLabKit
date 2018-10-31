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
  
  public init(network: Networking, hostURL: URL) {
    self.network = network
    self.hostURL = hostURL
  }
  
  public func object<T>(for request: APIRequesting) -> Observable<T> where T : Codable {
    var header = Header()
    if let privateToken = privateTokenVariable.value {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthTokenVariable.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
    
    guard let request = request.buildRequest(with: self.hostURL, header: header) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }
}

