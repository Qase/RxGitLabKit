//
//  AuthenticationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/01/2019.
//

import XCTest
import RxGitLabKit

class AuthenticationTests: BaseModelTestCase {
  
  let tokenData = """
{"access_token":"a14b22a2f1baf177528a2d4d140465c78a61a85d2d58b539c1808416a29bfe56","token_type":"bearer","refresh_token":"05f3d4c3ee5b00450b16a3099b552db59878900e9bc0ce9ccd33b151a10251b1","scope":"api","created_at":1543314915}
""".data()
  
  func testAuthenticationDecoding(){
    do {
      let token = try decoder.decode(Authentication.self, from: tokenData)
      XCTAssertEqual(token.oAuthToken, "a14b22a2f1baf177528a2d4d140465c78a61a85d2d58b539c1808416a29bfe56")
      XCTAssertEqual(token.tokenType, "bearer")
      XCTAssertEqual(token.refreshToken, "05f3d4c3ee5b00450b16a3099b552db59878900e9bc0ce9ccd33b151a10251b1")
      XCTAssertEqual(token.scope, "api")
      XCTAssertEqual(token.createdAt, 1543314915)
      XCTAssertDateEqual(token.createdAtDate, Date(timeIntervalSince1970: 1543314915))
    } catch let error {
       XCTFail("Failed to decode authentication. \n Error:\(error.localizedDescription)")
    }
  }
}
