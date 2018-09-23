//
//  RxGitLabAPIClientTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import XCTest
import RxGitLabKit
import RxSwift

class DevelopmentPlaygroundTests: XCTestCase {
  
 
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
  
  func testAuthentication2() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
      
    
    let bag = DisposeBag()
    
    let username = "tranaduc"
    let password = "nV4-ubr-M8V-LFx"
    
    //    XCTAssert(client.test == "tesst")
    
    let authentication = client.authentication.authenticate(username: username, password: password)
    let expectation = XCTestExpectation(description: "response")
    authentication.subscribe { event in
      print(event)
      expectation.fulfill()
      }.disposed(by: bag)
    wait(for: [expectation], timeout: 1)
  }
  
}
