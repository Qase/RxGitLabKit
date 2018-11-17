//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class EndpointGroup {
  
  public let hostCommunicator: HostCommunicator

  public let perPage = Variable<Int>(100)
  
  public let disposeBag = DisposeBag()

  public enum Enpoints {}

  public required init(with hostCommunicator: HostCommunicator) {
    self.hostCommunicator = hostCommunicator
  }
  
  public func object<T>(for apiRequest: APIRequesting, apiVersion: String? = RxGitLabAPIClient.apiVersionURLString) -> Observable<T> where T: Codable {
    return hostCommunicator.object(for: apiRequest, apiVersion: apiVersion)
  }
  
  public func data(for apiRequest: APIRequesting) -> Observable<Data> {
    return hostCommunicator.data(for: apiRequest)
  }
  
  public func response(for apiRequest: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return hostCommunicator.response(for: apiRequest)
  }
  
  public func httpURLResponse(for apiRequest: APIRequesting) -> Observable<HTTPURLResponse> {
    return hostCommunicator.httpURLResponse(for: apiRequest)
  }
}
