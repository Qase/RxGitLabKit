//
//  UsersTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
import RxGitLabKit

class UsersTests: XCTestCase {

func testUserDecode() {

    let data = UserMocks.fullUserData

    let decoder = JSONDecoder()
    if let user = try? decoder.decode(User.self, from: data) {
      XCTAssert(user.username == "freak4pc")
      XCTAssert(user.name == "Shai Mishali")
      XCTAssert(user.state == "active")
      XCTAssert(user.avatarUrl == "http://c20945ccd3bd/uploads/-/system/user/avatar/2/605076.jpeg")
      XCTAssert(user.webUrl == "http://c20945ccd3bd/freak4pc")
      XCTAssert(user.bio == nil)
      XCTAssert(user.linkedin != nil && user.linkedin!.isEmpty)

      let timeZone = TimeZone(secondsFromGMT: 0)
      let calendar = Calendar(identifier: .gregorian)
      var components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 10, day: 30, hour: 10, minute: 41, second: 22)
      var date = calendar.date(from: components)!
      XCTAssertDateEqual(user.createdAt, date)
      
      components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 10, day: 30, hour: 10, minute: 41, second: 22)
      date = calendar.date(from: components)!
      XCTAssertDateEqual(user.confirmedAt, date)
      
      
      } else {
      XCTFail("JSON Decode fail")
    }
  }
}
