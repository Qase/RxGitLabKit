//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

class Endpoint {
  let network: Networking
  let hostURL: URL
  var privateToken = Variable<String?>(nil)
  var oAuthToken = Variable<String?>(nil)
  let disposeBag = DisposeBag()
  
  required init(network: Networking, hostURL: URL) {
    self.network = network
    self.hostURL = hostURL
  }
  
  enum Enpoints {}

  func object<T>(for request: APIRequesting) -> Observable<T> where T : Decodable, T : Encodable {

    var header = ["application/json" : "Accept"]
    if let privateToken = privateToken.value {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
    guard let request = request.buildRequest(with: self.hostURL, header: header) else { return Observable.error(NetworkingError.invalidRequest(message: nil)) }
    return network.object(for: request)
  }
}
