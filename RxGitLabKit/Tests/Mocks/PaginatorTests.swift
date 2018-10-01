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
  
  
  override func setUp() {
    super.setUp()
    //    URLProtocol.registerClass(MockURLProtocol.self)
    client = RxGitLabAPIClient(with: hostURL)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLoadAll() {
    let host = "https://gitlab.fel.cvut.cz"
    
    let client = RxGitLabAPIClient(with: URL(string: host)!)
    let expectation = XCTestExpectation(description: "response")
    
    client.oAuthToken.value = "[TOKEN]"
    
    let paginator = client.users.getUsers(page: 1, perPage: 100)
    
    paginator.loadAll()
      .asObservable()
      .subscribe (onNext: { value in
        print("Loading: \(Float(value.count) / Float(paginator.total) * 100.0) %" )
        if value.count == paginator.total {
          expectation.fulfill()
        }
      },
      onError: { error in
        print(error)
      })
    wait(for: [expectation], timeout: 100)
    
  }
}
