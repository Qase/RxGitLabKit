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
  public let page: Variable<Int>
  let perPage: Variable<Int>
  let privateToken = Variable<String?>(nil)
  public let oAuthToken = Variable<String?>(nil)
  public let list = Variable<[T]>([])
//  var pageList: Variable<[T]>?
  
  let refreshTrigger = PublishSubject<Void>()
  let loadNextPageTrigger = PublishSubject<Void>()
  let loading = Variable<Bool>(false)
  let error = PublishSubject<Swift.Error>()
  public let disposeBag = DisposeBag()

  required public init(network: Networking, hostURL: URL, apiRequest: APIRequest, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) {
    self.network = network
    self.hostURL = hostURL
    self.apiRequest = apiRequest
    self.page = Variable<Int>(page)
    self.perPage = Variable<Int>(perPage)
    
//    let refreshRequest = loading.asObservable()
//      .sample(self.page.asObservable())
//
//    let refreshRequest = self.page.asObservable()
//      .flatMap { loading -> Observable<Int> in
//        if loading {
//          return Observable.empty()
//        } else {
//          return Observable<Int>.create { observer in
//            observer.onNext(self.page.value)
//            observer.onCompleted()
//            return Disposables.create()
//          }
//        }
//      }
    
//    let nextPageRequest = loading.asObservable()
//      .sample(loadNextPageTrigger)
      let nextPageRequest = loadNextPageTrigger.asObservable()
      .flatMap { [unowned self] _ -> Observable<Int> in
//        if loading {
//          return Observable.empty()
//        } else {
          return Observable<Int>.create { [unowned self] observer in
            self.page.value += 1
            observer.onNext(self.page.value)
            observer.onCompleted()
            return Disposables.create()
          }
//        }
      }
    
    let request = Observable
      .of(self.page.asObservable(), nextPageRequest)
      .merge()
//      .share(replay: 2, scope: .whileConnected)
    
    request.subscribe(onNext: { offset in
      print("Page \(offset) requested")
    }).disposed(by: disposeBag)
    
    loadNextPageTrigger.subscribe(onNext: { _ in
      print("loadNextPageTrigger fired")
    })
      .disposed(by: disposeBag)
    
    let response = request.flatMap { [unowned self] offset -> Observable<[T]> in
      self.loadData(page: offset, perPage: self.perPage.value)
        .do(onError: { [weak self] error in
          self?.error.onError(error)
          print(error)
        })
        .catchError { error -> Observable<[T]> in Observable.empty() }
      }
//        .share(replay: 1, scope: .whileConnected)
//    response
//      .subscribe(onNext: { lst in
//        print(lst)
//        for user in lst {
//          print(user)
//        }
//      })
//      .disposed(by: disposeBag)
    
    Observable
      .combineLatest(request, response, list.asObservable()) { [unowned self] request, response, elements in
        return self.page.value == 0 ? response : elements + response }
      .sample(response)
      .bind(to: list)
//      .subscribe(onNext: { lst in
//        print(lst)
//      })
      .disposed(by: disposeBag)
    
//    Observable
//      .of(request.map {_ in true}, response.map { $0.count == 0 }, error.map { _ in false })
//      .merge()
//      .bind(to: loading)
//      .disposed(by: disposeBag)

  }
  
  public func loadNextPage() {
    loadNextPageTrigger.onNext(())
  }
  
  public func loadData<T>(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[T]> where T : Codable {
    var header = Header()
    if let privateToken = privateToken.value {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
//    header["page"] = "\(page)"
//    header["per_page"] = "\(perPage)"
    
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: header, page: page, perPage: perPage) else { return Observable.error(NetworkingError.invalidRequest(message: "invalid"))}
    
    return network.object(for: request)
  }
  
  public func load() -> Observable<Header> {
    var header = Header()
    if let privateToken = privateToken.value {
      header["Private-Token"] = privateToken
    }
    if let oAuthToken = oAuthToken.value {
      header["Authorization"] = "Bearer \(oAuthToken)"
    }
    apiRequest.method = .head
    guard let request = apiRequest.buildRequest(with: self.hostURL, header: header) else { return Observable.error(NetworkingError.invalidRequest(message: "invalid"))}
    
    return network.header(for: request)
//      .subscribe(onNext: { (header) in
//        print(header)
//      }, onError: nil, onCompleted: nil, onDisposed: nil)
    
  }
  
}
