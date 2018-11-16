//
//  Paginator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class Paginator<T: Codable>: HostCommunicator {

  // MARK: Private constants
  private let apiRequest: APIRequest
  public let pageVariable = Variable<Int>(-1)
  public let perPageVariable = Variable<Int>(-1)
  public let totalPagesVariable = Variable<Int>(-1)
  public let totalVariable = Variable<Int>(-1)
  public let currentPageListVariable = Variable<[T]>([])

  public var currentPageListObservable: Observable<[T]> {
   return currentPageListVariable.asObservable()
  }

  public var currentPageList: [T] {
    return currentPageListVariable.value
  }

  required public init(network: Networking, hostURL: URL, apiRequest: APIRequest, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage, oAuthToken: Variable<String?>, privateToken: Variable<String?>) {
    self.apiRequest = apiRequest
    self.pageVariable.value = page
    self.perPageVariable.value = perPage
    super.init(network: network, hostURL: hostURL)
    oAuthToken.asObservable()
      .bind(to: oAuthTokenVariable)
      .disposed(by: disposeBag)
    privateToken.asObservable()
      .bind(to: privateTokenVariable)
      .disposed(by: disposeBag)
  }

  // MARK: Public Functions

  /// Loads objects from the endpoint.
  ///
  /// - Parameters:
  ///   - page: Page which should be loaded (default is 1)
  ///   - perPage: How many objects in a page should be loaded (default is 20, maximum is 100)
  /// - Returns: An observable of array of loaded objects
  public func loadPage(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage, isChangingState: Bool = false) -> Observable<[T]> {

    if isChangingState {
      self.pageVariable.value = page
      self.perPageVariable.value = perPage
    }

    var header = Header()
    if let privateTokenValue = privateTokenVariable.value {
      header[HeaderKeys.privateToken.rawValue] = privateTokenValue
    }
    if let oAuthTokenValue = oAuthTokenVariable.value {
      header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthTokenValue)"
    }

    guard let request = apiRequest.buildRequest(with: self.hostURL, header: header, page: page, perPage: perPage) else { return Observable.error(HTTPError.invalidRequest(message: "invalid"))}

    return network.object(for: request).do(onNext: { (elements) in
      self.currentPageListVariable.value = elements
    })
  }

  /// Loads items from the next page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadNextPage() -> Observable<[T]> {
    pageVariable.value += 1
    return loadPage(page: pageVariable.value, perPage: perPageVariable.value)
  }

  /// Loads items on from the previous page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadPreviousPage() -> Observable<[T]> {
    pageVariable.value -= 1
    return loadPage(page: pageVariable.value, perPage: perPageVariable.value)
  }

  /// Loads items from the first page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadFirstPage() -> Observable<[T]> {
    pageVariable.value = 1
    return loadPage(page: pageVariable.value, perPage: perPageVariable.value)
  }

  private var header: Observable<Header> {
    get {
      var header = Header()
      if let privateToken = self.privateTokenVariable.value {
        header[HeaderKeys.privateToken.rawValue] = privateToken
      }
      if let oAuthToken = self.oAuthTokenVariable.value {
        header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthToken)"
      }

      var headAPIRequest = self.apiRequest // apiRequest is a struct and the original should not be changed
      headAPIRequest.method = .head

      guard let request = headAPIRequest.buildRequest(with: hostURL, header: header, page: pageVariable.value, perPage: perPageVariable.value) else { return Observable.error(HTTPError.invalidRequest(message: "invalid")) }

      // Get the number of pages
      return network.header(for: request)
        .filter({ !$0.isEmpty })
    }
  }

  /// Loads all objects from the endpoint.
  ///
  /// - Returns: An observable of array of loaded objects
  public func loadAll() -> Observable<[T]> {
    let allListVariable = Variable<[T]>([])

    // Get the number of pages
    let headerResponse = header
          .flatMap { header -> Observable<(Int, [Int])> in
            guard let _perPage = header[HeaderKeys.perPage.rawValue],
              let perPage = Int(_perPage),
              let _totalPages = header[HeaderKeys.totalPages.rawValue],
              let totalPages = Int(_totalPages),
              let _total = header[HeaderKeys.total.rawValue],
              let total = Int(_total)
              else { return Observable.error(RxError.unknown) }

            self.perPageVariable.value = perPage
            self.totalPagesVariable.value = totalPages
            self.totalVariable.value = total
            return Observable.just((perPage, Array(1...totalPages)))
          }

    let arrayOfObservables: Observable<[Observable<[T]>]> = headerResponse
      .map { (arg) -> [Observable<[T]>] in
      let (perPage, pages) = arg
      return pages.map { page in
        return self.loadPage(page: page, perPage: perPage)
      }
    }

    let mergedObjects: Observable<[T]> = arrayOfObservables.flatMap { arg -> Observable<[T]> in
      Observable.from(arg).merge()
    }
    let wholeSequence = mergedObjects.toArray().do(onNext: { value in
      allListVariable.value = value.flatMap { $0 }
    })

    let ret = wholeSequence.flatMap { arg -> Observable<[T]> in
      if arg.filter({ (elements) -> Bool in
        elements.isEmpty
      }).count > 0 {
        return Observable.error(RxError.unknown)
      } else {
        return allListVariable.asObservable()
      }
    }

    return ret
  }

}
