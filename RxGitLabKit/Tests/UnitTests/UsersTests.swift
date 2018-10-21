//
//  UsersTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest

class UsersTests: XCTestCase {

func testUserDecode() {
    let user = """
  {
    "id": 1,
    "username": "john_smith",
    "name": "John Smith",
    "state": "active",
    "avatar_url": "http://localhost:3000/uploads/user/avatar/1/cd8.jpeg",
    "web_url": "http://localhost:3000/john_smith",
    "created_at": "2012-05-23T08:00:58Z",
    "bio": null,
    "location": null,
    "skype": "",
    "linkedin": "",
    "twitter": "",
    "website_url": "",
    "organization": ""
  }
  """
    let data = user.data(using: .utf8)!
  
    let decoder = JSONDecoder()
    if let user = try? decoder.decode(User.self, from: data) {
      XCTAssert(user.username == "john_smith")
      XCTAssert(user.name == "John Smith")
      XCTAssert(user.state == "active")
      XCTAssert(user.avatarUrl == "http://localhost:3000/uploads/user/avatar/1/cd8.jpeg")
      XCTAssert(user.webUrl == "http://localhost:3000/john_smith")
      XCTAssert(user.bio == nil)
      XCTAssert(user.linkedin != nil && user.linkedin!.isEmpty)
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      XCTAssert(dateFormatter.date(from: user.createdAt!) != nil)
    } else {
      XCTFail("JSON Decode fail")
    }
  }

}
