//
//  AuthenticationEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 29/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class AuthenticationEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testAuthenticate() {
    let result = client.authentication.authenticate(username: "root", password: "admin12345")
      .toBlocking(timeout: self.defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements.count, 1)
      if let authentication = elements.first {
        XCTAssertNotNil(authentication.oAuthToken)
        XCTAssertEqual(authentication.tokenType, "bearer")
        XCTAssertNotNil(authentication.refreshToken)
        XCTAssertEqual(authentication.scope, "api")
        XCTAssertNotNil(authentication.createdAt)
      } else {
        XCTFail("Authentication is nil.")
      }
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
}
