//
//  RxGitLabAPIClientUnitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class RxGitLabAPIClientUnitTests: XCTestCase {

  private var client: RxGitLabAPIClient!
  private var mockSession: MockURLSession!

  private let hostURL = URL(string: "test.gitlab.com")!

  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    let hostCommunicator = HostCommunicator(network: HTTPClient(using: mockSession), hostURL: hostURL)
    client = RxGitLabAPIClient(with: hostCommunicator)
  }

  func testLogin() {
    mockSession.nextData = AuthenticationMocks.oAuthResponseData
    client.logIn(username: AuthenticationMocks.username, password: AuthenticationMocks.password)
      let result = client.oAuthTokenVariable.asObservable()
        .take(1)
        .toBlocking()
        .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first ?? nil)
      XCTAssertNil(client.privateToken)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
}
