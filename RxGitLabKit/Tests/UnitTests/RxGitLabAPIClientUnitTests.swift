//
//  RxGitLabAPIClientUnitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation
import XCTest
import RxGitLabKit
import RxSwift
import RxGitLabKit

class RxGitLabAPIClientUnitTests: XCTestCase {
  
  private var client: RxGitLabAPIClient!
  private var mockSession: MockURLSession!
  
  private let hostURL = URL(string: "test.gitlab.com")!
  
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    client = RxGitLabAPIClient(with: hostURL, using: HTTPClient(using: mockSession))
  }
  
  
  func testGetOAuthToken() {
    mockSession.nextData = AuthenticationMocks.oAuthResponseData
    let result = client.getOAuthToken(username: AuthenticationMocks.mockLogin[.username]!, password: AuthenticationMocks.mockLogin[.password]!)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let authentication = elements.first!
      print(authentication)
      XCTAssertEqual(authentication.oAuthToken, AuthenticationMocks.mockLogin[.oAuthToken]!)
      XCTAssertEqual(authentication.tokenType, "bearer")
      XCTAssertEqual(authentication.refreshToken, "96pl81b5d7dd524dc3b96c88c3cd3c62365769b9bef2b11c9995b2b5526c584")
      XCTAssertEqual(authentication.createdAt, 1534516936)
      XCTAssertEqual(authentication.scope, "api")
      
      do {
        let dict: [String: String] = try JSONSerialization.jsonObject(with: mockSession.lastRequest!.httpBody!) as! [String: String]
        XCTAssertEqual(dict["grant_type"]!, "password")
        XCTAssertEqual(dict["username"]!, AuthenticationMocks.mockLogin[.username])
        XCTAssertEqual(dict["password"]!, AuthenticationMocks.mockLogin[.password])
      } catch let error {
        XCTFail(error.localizedDescription)
      }
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
    
  }
  
  func testLogin() {
    mockSession.nextData = AuthenticationMocks.oAuthResponseData
    let result = client.login(username: AuthenticationMocks.mockLogin[.username]!, password: AuthenticationMocks.mockLogin[.password]!)
      .toBlocking()
    .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      XCTAssertTrue(elements.first!)
      
      XCTAssertNotNil(mockSession.lastRequest?.httpBody)
      do {
        let dict: [String: String] = try JSONSerialization.jsonObject(with: mockSession.lastRequest!.httpBody!) as! [String: String]
      XCTAssertEqual(dict["grant_type"]!, "password")
      XCTAssertEqual(dict["username"]!, AuthenticationMocks.mockLogin[.username])
      XCTAssertEqual(dict["password"]!, AuthenticationMocks.mockLogin[.password])
      } catch let error {
        XCTFail(error.localizedDescription)
      }

      XCTAssertEqual(client.oAuthTokenVariable.value, AuthenticationMocks.mockLogin[.oAuthToken])
      XCTAssertNil(client.privateTokenVariable.value)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
}
