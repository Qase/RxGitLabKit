//
//  RxGitLabAPIClientIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 20/08/2018.
//

// TODO : Refactor

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class RxGitLabAPIClientIntegrationTests: XCTestCase {

  private var client: RxGitLabAPIClient!
  private var hostCommunicator: HostCommunicator!
  private let hostURL = URL(string: "https://gitlab.fel.cvut.cz")!
  
  override func setUp() {
    super.setUp()
    hostCommunicator = HostCommunicator(hostURL: hostURL)
    client = RxGitLabAPIClient(with: hostCommunicator)
  }

  func testLogin() {
    client.logIn(username: AuthenticationMocks.username, password: AuthenticationMocks.password)
    let result = client.oAuthTokenVariable.asObservable()
      .filter{ $0 != nil }
      .take(1)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first ?? nil)
      XCTAssertEqual(elements.first!, AuthenticationMocks.oAuthToken)

      XCTAssertNil(client.privateToken)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
}
