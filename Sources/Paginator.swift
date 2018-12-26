//
//  ArrayPaginator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 15/11/2018.
//

import Foundation
import RxSwift

/// This class handles pagination of the [GitLab API](https://docs.gitlab.com/ee/api/#pagination).
///
/// The pages can be retrieved using `subscript`. The subscript supports index and also a range.
/// Sample code:
///```swift
/// let paginator = client.users.getUsers()
///let usersObservable = p[2...5]
///usersObservable.subscribe(onNext: { users in
///  // do something with users
///})
///```
public class Paginator<T: Codable> {
  
  // MARK: Private constants
  /// API Request containing data about the endpoint
  private let apiRequest: APIRequest
  
  /// How many maximum objects per page are loaded
  private let perPage: Int
  
  /// Communication module
  private let communicator: HostCommunicator
  
  // MARK: Computed variables
  
  /// Returns and Observable of the total number pages on given endpoint
  public var totalPages: Observable<Int> {
    var newApiRequest = apiRequest
    newApiRequest.parameters["per_page"] = perPage
    return communicator
      .header(for: newApiRequest)
      .map({ header -> Int in
        guard let _page = header[HeaderKeys.totalPages.rawValue], let pagesCount = Int(_page) else { return 0 }
        return pagesCount
      })
  }
  
  /// Returns and Observable of the total number of objects on given endpoint
  public var totalItems: Observable<Int> {
    var newApiRequest = apiRequest
    newApiRequest.parameters["per_page"] = perPage
    return communicator
      .header(for: newApiRequest)
      .map({ header -> Int in
        guard let _page = header[HeaderKeys.total.rawValue], let pagesCount = Int(_page) else { return 0 }
        return pagesCount
      })
  }
  
  // MARK: Init
  required public init(communicator: HostCommunicator, apiRequest: APIRequest, perPage: Int = RxGitLabAPIClient.defaultPerPage) {
    self.communicator = communicator
    self.apiRequest = apiRequest
    self.perPage = perPage
  }
  
  // MARK: Subscripts
  
  /// Enables using index for loading a page
  ///
  /// - Parameter index: index of the desired page
  public subscript(index: Int) -> Observable<[T]> {
    return loadPage(page: index)
  }
  
  /// Enables using a range for loading a page
  ///
  /// - Parameter range: Range
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
  
  /// Enables using a closed range for loading a page
  ///
  /// - Parameter closedRange: closed range
  public subscript(closedRange: ClosedRange<Int>) -> Observable<[T]> {
    let range = Range(closedRange)
    return self[range]
  }
  
  // MARK: Functions
  
  /// Loads all items from the endpoint
  public func loadAll() -> Observable<[T]> {
    return totalPages.flatMap { $0 > 1 ? self[1...$0] : self[1] }
  }
  
  /// Fetches objects on the specified page
  ///
  /// - Parameter page: the page from which the items should be fetched
  private func loadPage(page: Int) -> Observable<[T]> {
    var newApiRequest = apiRequest
    newApiRequest.parameters["page"] = page
    newApiRequest.parameters["per_page"] = perPage
    
    return communicator
      .object(for: newApiRequest)
  }
  
}
