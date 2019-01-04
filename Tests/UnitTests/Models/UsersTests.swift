//
//  UsersTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
import RxGitLabKit

class UsersTests: BaseModelTestCase {
  
  func testUserDecode() {
    do {
      let user = try decoder.decode(User.self, from: UserMocks.fullUserData)
      XCTAssertEqual(user.username, "freak4pc")
      XCTAssertEqual(user.name, "Shai Mishali")
      XCTAssertEqual(user.state, "active")
      XCTAssertEqual(user.avatarURL, "http://c20945ccd3bd/uploads/-/system/user/avatar/2/605076.jpeg")
      XCTAssertEqual(user.webURL, "http://c20945ccd3bd/freak4pc")
      XCTAssertNil(user.bio)
      XCTAssertTrue(user.linkedin != nil && user.linkedin!.isEmpty)
      XCTAssertDateEqual(user.createdAt, Date(from: "2018-10-30T10:41:22.710Z"))
      XCTAssertDateEqual(user.confirmedAt, Date(from: "2018-10-30T10:41:22.710Z"))
    }  catch let error {
      XCTFail("Failed to decode an user. Error: \(error.localizedDescription)")
    }
  }
}
