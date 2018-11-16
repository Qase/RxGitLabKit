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
    let arrayOfObservables: [Observable<(Int, [T])>] = range
      .map { page in self.loadPage(page: page).map {(page, $0)}}

    let mergedObjects: Observable<[T]> = Observable
      .zip(arrayOfObservables)
      .map { arrayOfTuples -> [(Int, [T])] in
        arrayOfTuples.sorted(by: { (lhs, rhs) -> Bool in
          return lhs.0 < rhs.0
        })}
      .map { arrayOfTuples -> [T] in
        arrayOfTuples.flatMap {$0.1}
      }
    
    return mergedObjects
  }
  
  public subscript(closedRange: ClosedRange<Int>) -> Observable<[T]> {
    let range = Range(closedRange)
    return self[range]
  }
  
  
  public var totalPages: Observable<Int> {
    return communicator
      .header(for: apiRequest)
      .map({ header -> Int in
        guard let _page = header[HeaderKeys.totalPages.rawValue], let pagesCount = Int(_page) else { return 0 }
        return pagesCount
      })
  }

  public func loadAll() -> Observable<[T]> {
    return totalPages.flatMap { self[1...$0] }
  }
  
  private func loadPage(page: Int) -> Observable<[T]> {
    var newApiRequest = apiRequest
    newApiRequest.parameters["page"] = page
    newApiRequest.parameters["perPage"] = perPage

    return communicator
      .object(for: newApiRequest)
  }
  
}
