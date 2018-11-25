//
//  RxGitLabAPIClientIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 20/08/2018.
//

// TODO : Refactor

import Foundation
import XCTest
import RxGitLabKit
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

  func testGetToken() {
    let result = client.getOAuthToken(username: AuthenticationMocks.username, password: AuthenticationMocks.password)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let token = elements.first!
      print(token)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testLogin() {
    let result = client.login(username: AuthenticationMocks.username, password: AuthenticationMocks.password)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let token = elements.first!
      print(token)
      XCTAssertNotNil(client.oAuthTokenVariable.value)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
}
