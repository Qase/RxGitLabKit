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
  
  private let bag = DisposeBag()
  
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
  
  
  func testVariable() {
    
    let source = Variable<String?>(nil)
    let destination = Variable<String?>(nil)
    
    source.value = "Start"
    
    source.asObservable()
      .bind(to: destination)
    
    
    destination.asObservable()
      .subscribe { event in
        print(event)
        print(event.element)
    }
    
    
    wait(for: [], timeout: 100)
  }
  
  func testLoadAll() {
    let host = "https://gitlab.fel.cvut.cz"
    
    let client = RxGitLabAPIClient(with: URL(string: host)!)
    let expectation = XCTestExpectation(description: "response")
    
    client.oAuthToken.value = "e379c3dd992dfb8043db912bb8ad6643130848184edad33358029a3176cabaec"
    
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
