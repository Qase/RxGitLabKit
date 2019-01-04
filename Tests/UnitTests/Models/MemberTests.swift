//
//  UsersTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import XCTest
import RxGitLabKit

class MemberTests: BaseModelTestCase {
  let memberData = """
{
    "id": 1,
    "username": "raymond_smith",
    "name": "Raymond Smith",
    "state": "active",
    "avatar_url": "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon",
    "web_url": "http://192.168.1.8:3000/root",
    "expires_at": "2012-10-22T14:13:35Z",
    "access_level": 30
  }
""".data()
  
  let membersData = """
[
  {
    "id": 1,
    "username": "raymond_smith",
    "name": "Raymond Smith",
    "state": "active",
    "avatar_url": "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon",
    "web_url": "http://192.168.1.8:3000/root",
    "expires_at": "2012-10-22T14:13:35Z",
    "access_level": 30
  },
  {
    "id": 2,
    "username": "john_doe",
    "name": "John Doe",
    "state": "active",
    "avatar_url": "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon",
    "web_url": "http://192.168.1.8:3000/root",
    "expires_at": "2012-10-22T14:13:35Z",
    "access_level": 30
  },
  {
    "id": 3,
    "username": "foo_bar",
    "name": "Foo bar",
    "state": "active",
    "avatar_url": "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon",
    "web_url": "http://192.168.1.8:3000/root",
    "expires_at": "2012-11-22T14:13:35Z",
    "access_level": 30
  }
]
""".data()
  
  func testMemberDecode() {
    do {
      let member = try decoder.decode(Member.self, from: memberData)
      XCTAssert(member.username == "raymond_smith")
      XCTAssert(member.name == "Raymond Smith")
      XCTAssert(member.state == "active")
      XCTAssert(member.avatarURL == "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon")
      XCTAssert(member.webURL == "http://192.168.1.8:3000/root")
      XCTAssert(member.accessLevel == 30)
      XCTAssertDateEqual(member.expiresAt, Date(from: "2012-10-22T14:13:35Z"))
    }  catch let error {
      XCTFail("Failed to decode a member. Error: \(error.localizedDescription)")
    }
  }
  
  func testMembersDecode() {
    do {
      let members = try decoder.decode([Member].self, from: membersData)
      XCTAssertEqual(members.count, 3)
      XCTAssert(members[0].username == "raymond_smith")
      XCTAssert(members[0].name == "Raymond Smith")
      XCTAssert(members[0].state == "active")
      XCTAssert(members[0].avatarURL == "https://www.gravatar.com/avatar/c2525a7f58ae3776070e44c106c48e15?s=80&d=identicon")
      XCTAssert(members[0].webURL == "http://192.168.1.8:3000/root")
      XCTAssert(members[0].accessLevel == 30)
      XCTAssertDateEqual(members[0].expiresAt, Date(from: "2012-10-22T14:13:35Z"))
    }  catch let error {
      XCTFail("Failed to decode a member. Error: \(error.localizedDescription)")
    }
  }
}
