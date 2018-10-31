//
//  PaginatorIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class PaginatorIntegrationTests: XCTestCase {
  
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
    let paginator = client.users.getUsers(page: 1, perPage: 100)
    let loadAllObservable = paginator.loadAll()

    // toBlocking doesn't work for some reason
//    let result = loadAllObservable.toBlocking().materialize()
//    switch result {
//    case .completed(elements: let elements):
//      XCTAssertEqual(elements.count,  paginator.total)
//    case .failed(elements: _, error: let error):
//      XCTFail(error.localizedDescription)
//    }
    
    let expectation = XCTestExpectation(description: "response")
    loadAllObservable
      .subscribe (onNext: { value in
        let countEquals = value.count == paginator.total
        XCTAssertTrue(countEquals)
        if countEquals {
          expectation.fulfill()
        }
      },
      onError: { error in
        XCTFail(error.localizedDescription)
        expectation.fulfill()
      })
      .disposed(by: disposeBag)
    wait(for: [expectation], timeout: timeoutInSeconds)

  }
  
  func testLoadPage() {
    let observable = client.users.getUsers().loadPage(page:1, perPage: 66)
    let result = observable.filter({ !$0.isEmpty }).toBlocking(timeout: 1000).materialize()
    switch result {
    case .completed(elements: let elements):
      XCTAssertGreaterThan(elements.count, 0)
      XCTAssertEqual(elements.first!.count,  66)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testFirstPage() {
    let paginator = client.users.getUsers(page: 2, perPage: 100)
    XCTAssertEqual(paginator.page, 2)
    let result = paginator.loadFirstPage()
      .filter({ !$0.isEmpty })
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertGreaterThan(elements.count, 0)
      XCTAssertEqual(elements.first!.count, 100)
      XCTAssertEqual(paginator.page, 1)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testNextPage() {
    let paginator = client.users.getUsers(page: 3, perPage: 100)
    XCTAssertEqual(paginator.page, 3)
    let result = paginator.loadNextPage()
      .filter({ !$0.isEmpty })
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertGreaterThan(elements.count, 0)
      XCTAssertEqual(elements.first!.count, 100)
      XCTAssertEqual(paginator.page, 4)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPreviousPage() {
    let paginator = client.users.getUsers(page: 3, perPage: 100)
    XCTAssertEqual(paginator.page, 3)
    let result = paginator.loadPreviousPage()
      .filter({ !$0.isEmpty })
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertGreaterThan(elements.count, 0)
      XCTAssertEqual(elements.first!.count, 100)
      XCTAssertEqual(paginator.page, 2)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  
}
