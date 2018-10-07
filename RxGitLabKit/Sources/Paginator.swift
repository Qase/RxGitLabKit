//
//  Paginator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class Paginator<T: Codable> {

  // MARK: Private constants
  private let apiRequest: APIRequest
  private let network: Networking
  private let hostURL: URL
  private let privateTokenVariable: Variable<String?>
  private let oAuthTokenVariable: Variable<String?>
  private let pageVariable: Variable<Int>
  private let perPageVariable: Variable<Int>
  private let totalPagesVariable: Variable<Int>
  private let totalVariable: Variable<Int>
  private let currentPageListVariable = Variable<[T]>([])
  private let allListVariable = Variable<[T]>([])
  private let loadPageSubject = PublishSubject<(Int, Int)>()
  private let disposeBag = DisposeBag()
  
  // MARK: Public getters
  public var page: Int {
    get {
      return pageVariable.value
    }
    set {
      pageVariable.value = newValue
    }
  }
  
  public var perPage: Int {
    get {
      return perPageVariable.value
    }
    set {
      perPageVariable.value = newValue
    }
  }
  
  public var totalPages: Int {
    get {
      return totalPagesVariable.value
    }
    set {
      totalPagesVariable.value = newValue
    }
  }
  
  public var total: Int {
    get {
      return totalVariable.value
    }
    set {
      totalVariable.value = newValue
    }
  }

  public var currentPageListObservable: Observable<[T]> {
   return currentPageListVariable.asObservable()
  }
  
  public var currentPageList: [T] {
    return currentPageListVariable.value
  }
  
  public var allListObservable: Observable<[T]> {
    return allListVariable.asObservable()
  }
  
  public var allList: [T] {
    return allListVariable.value
  }
  
  required public init(network: Networking, hostURL: URL, apiRequest: APIRequest, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage, oAuthToken: Variable<String?>, privateToken: Variable<String?>) {
    self.network = network
    self.hostURL = hostURL
    self.apiRequest = apiRequest
    self.pageVariable = Variable<Int>(page)
    self.perPageVariable = Variable<Int>(perPage)
    self.totalVariable = Variable<Int>(-1)
    self.totalPagesVariable = Variable<Int>(-1)
    self.oAuthTokenVariable = oAuthToken
    self.privateTokenVariable = privateToken
    
    loadPageSubject.asObservable()
      .flatMap { self.loadData(page: $0.0, perPage: $0.1) }
      .bind(to: self.currentPageListVariable)
      .disposed(by: disposeBag)
    
    header()
      .subscribe(onNext: { header in
        guard let _perPage = header[HeaderKeys.perPage.rawValue],
          let perPage = Int(_perPage),
          let _totalPages = header[HeaderKeys.totalPages.rawValue],
          let totalPages = Int(_totalPages),
          let _total = header[HeaderKeys.total.rawValue],
          let total = Int(_total)
          else { return }
        self.perPage = perPage
        self.totalPages = totalPages
        self.total = total
      })
      .disposed(by: disposeBag)
    
  }
  
  // MARK: Public Functions
  
  /// Loads items from the next page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadNextPage() {
    page += 1
    loadPage(page: page, perPage: perPage)
  }
  
  /// Loads items on from the previous page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadPreviousPage() {
    page -= 1
    loadPage(page: page, perPage: perPage)
  }
  
  /// Loads items from the first page
  /// The items will be emmitted from `currentPageListObservable`
  public func loadFirstPage() {
    page = 1
    loadPage(page: page, perPage: perPage)
  }
  
  /// Loads objects from the endpoint and emmits them from `currentPage
  ///
  /// - Parameters:
  ///   - page: Page which should be loaded (default is 1)
  ///   - perPage: How many objects in a page should be loaded (default is 20, maximum is 100)
  /// - Returns: An observable of array of loaded objects
  public func loadPage(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) {
   loadPageSubject.onNext((page, perPage))
  }
  
  /// Loads objects from the endpoint.
  ///
  /// - Parameters:
  ///   - page: Page which should be loaded (default is 1)
  ///   - perPage: How many objects in a page should be loaded (default is 20, maximum is 100)
  /// - Returns: An observable of array of loaded objects
  private func loadData(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[T]> {
    var header = Header()
    if let privateToken = privateTokenVariable.value {
      header[HeaderKeys.privateToken.rawValue] = privateToken
    }
    if let oAuthToken = oAuthTokenVariable.value {
      header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthToken)"
    }
    
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: header, page: page, perPage: perPage) else { return Observable.error(NetworkingError.invalidRequest(message: "invalid"))}
    
    return network.object(for: request)
  }
  
  private func header() -> Observable<Header> {
    var header = Header()
    if let privateToken = privateTokenVariable.value {
      header[HeaderKeys.privateToken.rawValue] = privateToken
    }
    if let oAuthToken = oAuthTokenVariable.value {
      header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthToken)"
    }
    
    var headAPIRequest = apiRequest // apiRequest is a struct and the original should not be changed
    headAPIRequest.method = .head
    
    guard let request = headAPIRequest.buildRequest(with: self.hostURL, header: header, page: self.page, perPage: self.perPage) else { return Observable.error(NetworkingError.invalidRequest(message: "invalid")) }
    
    // Get the number of pages
    return network.header(for: request)
      .filter({ !$0.isEmpty })
  }
  
  /// Loads all objects from the endpoint.
  ///
  /// - Returns: An observable of array of loaded objects
  public func loadAll() -> Observable<[T]> {
    
    // Get the number of pages
    let headerResponse = header()
          .flatMap { header -> Observable<(Int, [Int])> in
            guard let _perPage = header[HeaderKeys.perPage.rawValue],
              let perPage = Int(_perPage),
              let _totalPages = header[HeaderKeys.totalPages.rawValue],
              let totalPages = Int(_totalPages),
              let _total = header[HeaderKeys.total.rawValue],
              let total = Int(_total)
              else { return Observable.error(RxError.unknown) }
    
            self.perPage = perPage
            self.totalPages = totalPages
            self.total = total
            return Observable.just((perPage, Array(1...totalPages)))
          }

    let arrayOfObservables: Observable<[Observable<[T]>]> = headerResponse
      .map { (arg) -> [Observable<[T]>] in
      let (perPage, pages) = arg
      return pages.map { page in
        return self.loadData(page: page, perPage: perPage)
      }
    }
    
    let mergedObjects: Observable<[T]> = arrayOfObservables.flatMap { arg -> Observable<[T]> in
      Observable.from(arg).merge()
    }
    
    let wholeSequence = mergedObjects.toArray().do(onNext: { value in
      self.allListVariable.value = value.flatMap { $0 }
    })
    
    let ret = wholeSequence.flatMap{ arg -> Observable<[T]> in
      if arg.filter({ (elements) -> Bool in
        elements.isEmpty
      }).count > 0 {
        return Observable.error(RxError.unknown)
      } else {
        return self.allListVariable.asObservable()
      }

    }
    
    return ret
  }
  
}