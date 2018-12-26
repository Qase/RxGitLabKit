//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift


/// This is a base class for all EndpointGroups
public class EndpointGroup {
  
  /// Communicator
  internal let hostCommunicator: HostCommunicator
  internal let disposeBag = DisposeBag()
  
  /// Endpoint enumeration
  internal enum Endpoints {}
  
  public required init(with hostCommunicator: HostCommunicator) {
    self.hostCommunicator = hostCommunicator
  }
  
  /// Object of type T from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<T>
  internal func object<T>(for apiRequest: APIRequest) -> Observable<T> where T: Codable {
    return hostCommunicator.object(for: apiRequest)
  }
  
  /// A server response with data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<(response: HTTPURLResponse, data: Data?)>
  internal func data(for apiRequest: APIRequest) -> Observable<Data> {
    return hostCommunicator.data(for: apiRequest)
  }
  
  /// A server response with data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<(response: HTTPURLResponse, data: Data?)>
  internal func response(for apiRequest: APIRequest) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return hostCommunicator.response(for: apiRequest)
  }
  
  /// A server response without data from APIRequest
  ///
  /// - Parameter apiRequest: api request
  /// - Returns: Observable<HTTPURLResponse>
  internal func httpURLResponse(for apiRequest: APIRequest) -> Observable<HTTPURLResponse> {
    return hostCommunicator.httpURLResponse(for: apiRequest)
  }
}
