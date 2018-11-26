//
//  PaginatorIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
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
    client.oAuthTokenVariable.value = AuthenticationMocks.oAuthToken

    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLoadAll() {
    let paginator = client.users.getUsers(page: 1, perPage: 100)
    let loadAllObservable = paginator.loadAll()
    let totalObservable = paginator.totalItems
    
    let totalResult = totalObservable
      .toBlocking()
      .materialize()
    
    var total = 0
    switch totalResult {
    case .completed(elements: let elements):
      total = elements[0]
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }

    // toBlocking doesn't work for some reason
    let result = loadAllObservable.toBlocking().materialize()
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements[0].count, total)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

}
