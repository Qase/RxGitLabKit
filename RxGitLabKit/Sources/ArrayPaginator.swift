//
//  ArrayPaginator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 15/11/2018.
//

import Foundation
import RxSwift

public class ArrayPaginator<T: Codable> {

  // MARK: Private constants
  private let apiRequest: APIRequest
  private let perPage: Int
  private let communicator: HostCommunicator

  required public init(communicator: HostCommunicator, apiRequest: APIRequest, perPage: Int = RxGitLabAPIClient.defaultPerPage) {
    self.communicator = communicator
    self.apiRequest = apiRequest
    self.perPage = perPage
  }
  
  public subscript(index: Int) -> Observable<[T]> {
    return loadPage(page: index)
  }
  
  public subscript(range: Range<Int>) -> Observable<[T]> {
    let arrayOfObservables: [Observable<[T]>] = range.map { self.loadPage(page: $0) }
    let mergedObjects: Observable<[T]> = Observable
      .zip(arrayOfObservables)
      .map { polePoli -> [T] in
        polePoli.flatMap { $0 }
      }

    return mergedObjects
  }
  
  public subscript(closedRange: ClosedRange<Int>) -> Observable<[T]> {
    let range = Range(closedRange)
    return self[range]
  }
  
  private func loadPage(page: Int) -> Observable<[T]> {
     guard let request = apiRequest.buildRequest(with: communicator.hostURL, page: page, perPage: perPage) else { return Observable.error(HTTPError.invalidRequest(message: "invalid"))}
    return communicator.network.object(for: request)
  }
	
}
