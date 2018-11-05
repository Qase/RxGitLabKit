//
//  EndpointGroupUnitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 04/11/2018.
//

import XCTest
import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class EndpointGroupUnitTests: XCTestCase {
  
  var client: RxGitLabAPIClient!
  let hostURL = URL(string: "https://gitlab.test.com")!
  let hostAPIURL = URL(string: "https://gitlab.test.com/api/v4")!
  var mockSession: MockURLSession!
  let calendar = Calendar(identifier: .gregorian)
  let bag = DisposeBag()
  
  override func setUp() {
    mockSession = MockURLSession()
    let mockHTTPClient = HTTPClient(using: mockSession)
    client = RxGitLabAPIClient(with: hostURL, using: mockHTTPClient)
  }
}
