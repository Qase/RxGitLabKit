//
//  MembersEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 29/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class MembersEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testGetSingleGroupMember() {
    let result = client.members
      .getSingle(groupID: 7, userID: 4)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard let member = element.first else {
        XCTFail("No member received.")
        return
      }
      XCTAssertEqual(member.id, 4)
      XCTAssertEqual(member.username, "kzaher")
      XCTAssertEqual(member.accessLevel, 30)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetGroupMembers() {
    let result = client.members
      .get(groupID: 7)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard var members = element.first else {
        XCTFail("No members received.")
        return
      }
       XCTAssertEqual(members.count, 4)
      if members.count != 4 {
        XCTFail("Members count doesn't match.")
      } else {
        members.sort { $0.id < $1.id }
        let usernames = ["root", "freak4pc", "bontoJR", "kzaher"]
        for i in 0..<4 {
          XCTAssertEqual(members[i].id, i+1)
          XCTAssertEqual(members[i].username, usernames[i])
        }
      }
      
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetAllGroupMembers() {
    let result = client.members
      .getAll(groupID: 7)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard var members = element.first else {
        XCTFail("No members received.")
        return
      }
      XCTAssertEqual(members.count, 4)
      if members.count != 4 {
        XCTFail("Members count doesn't match.")
      } else {
        members.sort { $0.id < $1.id }
        let usernames = ["root", "freak4pc", "bontoJR", "kzaher"]
        for i in 0..<4 {
          XCTAssertEqual(members[i].id, i+1)
          XCTAssertEqual(members[i].username, usernames[i])
        }
      }
      
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetSingleProjectMember() {
    let result = client.members
      .getSingle(projectID: 7, userID: 4)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard let member = element.first else {
        XCTFail("No member received.")
        return
      }
      XCTAssertEqual(member.id, 4)
      XCTAssertEqual(member.username, "kzaher")
      XCTAssertEqual(member.accessLevel, 20)
      XCTAssertNotNil(member.expiresAt)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetProjectMembers() {
    let result = client.members
      .get(projectID: 7)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard let members = element.first else {
        XCTFail("No user received.")
        return
      }
      
      XCTAssertEqual(members.count, 1)
      if members.count == 1 {
        let member = members[0]
        XCTAssertEqual(member.id, 4)
        XCTAssertEqual(member.username, "kzaher")
        XCTAssertEqual(member.accessLevel, 20)
        XCTAssertNotNil(member.expiresAt)
      } else {
        XCTFail("Members count doesn't match.")
      }
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetAllProjectMembers() {
    let result = client.members
      .getAll(projectID: 7)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      guard var members = element.first else {
        XCTFail("No members received.")
        return
      }
      XCTAssertEqual(members.count, 5)
      if members.count != 5 {
        XCTFail("Members count doesn't match.")
      } else {
        members.sort { $0.id < $1.id }
        let usernames = ["root", "freak4pc", "bontoJR", "kzaher", "kzaher"]
        for i in 0..<4 {
          XCTAssertEqual(members[i].id, i+1)
          XCTAssertEqual(members[i].username, usernames[i])
        }
      }
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }

  
}
