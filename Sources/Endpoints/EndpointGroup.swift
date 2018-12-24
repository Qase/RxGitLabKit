//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class EndpointGroup {
  
  internal let hostCommunicator: HostCommunicator
  internal let disposeBag = DisposeBag()
  
  public let perPage = Variable<Int>(100)


  internal enum Endpoints {}

  public required init(with hostCommunicator: HostCommunicator) {
    self.hostCommunicator = hostCommunicator
  }
  
  internal func object<T>(for apiRequest: APIRequesting, apiVersion: String? = RxGitLabAPIClient.apiVersionURLString) -> Observable<T> where T: Codable {
    return hostCommunicator.object(for: apiRequest, apiVersion: apiVersion)
  }
  
  internal func data(for apiRequest: APIRequesting) -> Observable<Data> {
    return hostCommunicator.data(for: apiRequest)
  }
  
  internal func response(for apiRequest: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return hostCommunicator.response(for: apiRequest)
  }
  
  internal func httpURLResponse(for apiRequest: APIRequesting) -> Observable<HTTPURLResponse> {
    return hostCommunicator.httpURLResponse(for: apiRequest)
  }
}
