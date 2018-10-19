//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class EndpointGroup {
  let network: Networking
  let hostURL: URL
  
  private (set) var privateToken = Variable<String?>(nil)
  private (set) var oAuthToken = Variable<String?>(nil)
  public let perPage = Variable<Int>(100)
  
  let disposeBag = DisposeBag()
  
  required public init(network: Networking, hostURL: URL) {
    self.network = network
    self.hostURL = hostURL
  }
  
  private enum Enpoints {}

  func object<T>(for request: APIRequesting) -> Observable<T> where T : Codable {
    var header = Header()
    if let privateToken = privateToken.value {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
    
    guard let request = request.buildRequest(with: self.hostURL, header: header) else { return Observable.error(HTTPError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }
}
