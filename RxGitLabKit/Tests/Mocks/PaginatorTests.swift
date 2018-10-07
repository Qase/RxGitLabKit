//
//  PaginatorTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
import RxGitLabKit
import RxSwift

class PaginatorTests: XCTestCase {
  
  private var client: RxGitLabAPIClient!
  private let hostURL = URL(string: "https://gitlab.fel.cvut.cz")!
  private let timeoutInSeconds = TimeInterval(5)
  private let disposeBag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    //    URLProtocol.registerClass(MockURLProtocol.self)
    client = RxGitLabAPIClient(with: hostURL)
    client.oAuthToken.value = GeneralMocks.mockLogin[.oAuthToken]
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLoadAll() {
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.users.getUsers(page: 1, perPage: 100)

    paginator.loadAll()
      .subscribe (onNext: { value in
        print("Loading: \(Float(value.count) / Float(paginator.total) * 100.0) %" )
        print(value.count)
        print(paginator.total)
        if value.count == paginator.total {
          expectation.fulfill()
        }
      },
      onError: { error in
        print(error)
      })
      .disposed(by: disposeBag)
    wait(for: [expectation], timeout: timeoutInSeconds)
    
  }
  
  func testLoadPage() {
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.users.getUsers(page: 1, perPage: 100)
    
    paginator.currentPageListObservable
      .filter({ !$0.isEmpty })
      .subscribe(onNext: { items in
            XCTAssertEqual(items.count, 66)
            expectation.fulfill()
        }, onError: { error in
      XCTFail(error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    paginator.loadPage(page: 2, perPage: 66)
    wait(for: [expectation], timeout: timeoutInSeconds)
  }
  
  func testFirstLastPage() {
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.users.getUsers(page: 2, perPage: 100)
    
    paginator.currentPageListObservable
      .filter({ !$0.isEmpty })
      .subscribe(onNext: { items in
        XCTAssertEqual(paginator.page, 1)
        expectation.fulfill()
      }, onError: { error in
        XCTFail(error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    paginator.loadFirstPage()
    wait(for: [expectation], timeout: 100)
  }
  
  func testNextPage() {
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.users.getUsers(page: 3, perPage: 100)
    
    paginator.currentPageListObservable
      .filter({ !$0.isEmpty })
      .subscribe(onNext: { items in
        XCTAssertEqual(paginator.page, 4)
        expectation.fulfill()
      }, onError: { error in
        XCTFail(error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    paginator.loadNextPage()
    wait(for: [expectation], timeout: 100)
  }
  
  func testPreviousPage() {
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.users.getUsers(page: 3, perPage: 100)
    
    paginator.currentPageListObservable
      .filter({ !$0.isEmpty })
      .subscribe(onNext: { items in
        XCTAssertEqual(paginator.page, 2)
        expectation.fulfill()
      }, onError: { error in
        XCTFail(error.localizedDescription)
      })
      .disposed(by: disposeBag)
    
    paginator.loadPreviousPage()
    wait(for: [expectation], timeout: 100)
  }
  
  
}
