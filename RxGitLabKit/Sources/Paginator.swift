//
//  Paginator.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class Paginator<T: Codable> {

  var apiRequest: APIRequest
  let network: Networking
  let hostURL: URL
  private let pageVariable: Variable<Int>
  private let perPageVariable: Variable<Int>
  private let totalPagesVariable: Variable<Int>
  private let totalVariable: Variable<Int>
  
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
  
  public let privateToken: Variable<String?>
  public let oAuthToken: Variable<String?>
  public let list = Variable<[T]>([])
  public let currentPageList = Variable<[T]>([])
  
  let refreshTrigger = PublishSubject<Void>()
  let loadNextPageTrigger = PublishSubject<Void>()
  let loading = Variable<Bool>(false)
  let error = PublishSubject<Swift.Error>()
  public let disposeBag = DisposeBag()

  required public init(network: Networking, hostURL: URL, apiRequest: APIRequest, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage, oAuthToken: Variable<String?>, privateToken: Variable<String?>) {
    self.network = network
    self.hostURL = hostURL
    self.apiRequest = apiRequest
    self.pageVariable = Variable<Int>(page)
    self.perPageVariable = Variable<Int>(perPage)
    self.totalVariable = Variable<Int>(-1)
    self.totalPagesVariable = Variable<Int>(-1)
    self.oAuthToken = oAuthToken
    self.privateToken = privateToken
    
    let nextPageRequest = loadNextPageTrigger.asObservable()
    .flatMap { [unowned self] _ -> Observable<Int> in
        return Observable<Int>.create { [unowned self] observer in
          self.page += 1
          observer.onNext(self.page)
          observer.onCompleted()
          return Disposables.create()
        }
    }
    
    let request = Observable
      .of(self.pageVariable.asObservable(), nextPageRequest)
      .merge()
    
    let response = request
      .sample(loadNextPageTrigger)
      .flatMap { [unowned self] offset -> Observable<[T]> in
      self.loadData(page: offset, perPage: self.perPage)
        .do(onError: { [weak self] error in
          self?.error.onError(error)
          print(error)
        })
        .catchError { error -> Observable<[T]> in Observable.empty() }
      }
    
    response.subscribe(onNext: { [weak self] items in
        self?.currentPageList.value = items
      }, onError: { [weak self] error in
        self?.error.onError(error)
        self?.currentPageList.value = []
      })
      .disposed(by: disposeBag)

    Observable
      .combineLatest(request, response, list.asObservable()) { [unowned self] request, response, elements in
        return self.page == 0 ? response : elements + response }
      .sample(response)
      .bind(to: list)
      .disposed(by: disposeBag)

  }
  
  public func loadNextPage() {
    loadNextPageTrigger.onNext(())
  }
  
  public func loadData(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[T]> {
    var header = Header()
    if let privateToken = privateToken.value {
      header[HeaderKeys.privateToken.rawValue] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthToken)"
    }

    guard let request = apiRequest.buildRequest(with: self.hostURL, header: header, page: page, perPage: perPage) else { return Observable.error(NetworkingError.invalidRequest(message: "invalid"))}
    
    return network.object(for: request)
  }
  
  public func loadAll() -> Variable<[T]> {
    var header = Header()
    if let privateToken = privateToken.value {
      header[HeaderKeys.privateToken.rawValue] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header[HeaderKeys.oAuthToken.rawValue] = "Bearer \(oAuthToken)"
    }
    
    var headAPIRequest = apiRequest // apiRequest is a struct
    headAPIRequest.method = .head
    
    if let request = headAPIRequest.buildRequest(with: self.hostURL, header: header, page: self.page, perPage: self.perPage) {

    network.header(for: request)
      .filter({ !$0.isEmpty })
      // TODO: Error handling
      .map { header -> (Int, [Int]) in
        guard let perPage = Int(header[HeaderKeys.perPage.rawValue]!),
          let totalPages = Int(header[HeaderKeys.totalPages.rawValue]!),
          let total = Int(header[HeaderKeys.total.rawValue]!)
          else { return (-1, []) }
        
        self.perPage = perPage
        self.totalPages = totalPages
        self.total = total
        return (perPage, Array(1...totalPages))
      }
      .subscribe(onNext: { (arg) in
        let (perPage, pages) = arg
        for page in pages {
          self.loadData(page: page, perPage: perPage)
            .subscribe(onNext: { [weak self] (elements) in
              elements.forEach { self?.list.value.append($0) }
            }, onError: { (error) in
              print(error)
            })
        }})
        .disposed(by: disposeBag)
    }
    
    return list
  }
  
}
