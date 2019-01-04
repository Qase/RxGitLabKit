//
//  AuthenticationEndpointGroupUnitTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 29/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class AuthenticationEndpointGroupUnitTests: EndpointGroupUnitTestCase {
  
  func testAuthenticate() {
    // Adding mocked response data
    mockSession.nextData = AuthenticationMocks.oAuthResponseData
    
    // Invoking the request
    let result = client.authentication.authenticate(username: "root", password: "admin12345")
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):

      // Request asserts
      XCTAssertEqual(mockSession.lastRequest?.httpMethod, HTTPMethod.post.rawValue)
      if let body = mockSession.lastRequest?.httpBody, let dict = try? JSONSerialization.jsonObject(with: body, options: .mutableContainers) as! [String: String]
      {
        XCTAssertNotNil(dict["grant_type"])
        XCTAssertNotNil(dict["username"])
        XCTAssertNotNil(dict["password"])
      } else {
        XCTFail("Body data is corrupted")
      }
      if let lastURL = mockSession.lastURL, lastURL.pathComponents.count == 3 {
        XCTAssertEqual(lastURL.pathComponents[0], "/")
        XCTAssertEqual(lastURL.pathComponents[1], "oauth")
        XCTAssertEqual(lastURL.pathComponents[2], "token")
      } else {
        XCTFail("Number of path components doesn't match.")
      }
      
      // Response asserts
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
