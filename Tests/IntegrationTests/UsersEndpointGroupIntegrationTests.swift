//
//  UserEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 28/11/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxAtomic
import RxBlocking
import RxTest

class UsersEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testGetUsers() {
    let paginator = client.users.getUsers(parameters: ["order_by" : "id", "sort" : "asc"])
    let loadAllObservable = paginator.loadAll()
    let totalObservable = paginator.totalItems
    
    let totalResult = totalObservable
      .toBlocking()
      .materialize()
    
    var total = 0
    switch totalResult {
    case .completed(elements: let elements):
      total = elements[0]
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
    
    let result = loadAllObservable
      .toBlocking()
      .materialize()
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements[0].count, total)
      let user = elements[0][0]
      print(String(data: try! JSONEncoder().encode(user), encoding: .utf8)!)
      XCTAssertEqual(user.id, 1)
      XCTAssertEqual(user.username, "root")
      XCTAssertEqual(user.name, "Administrator")
      XCTAssertEqual(user.state, "active")
      XCTAssertEqual(user.avatarUrl, "https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon")
      XCTAssert(user.bio == nil)
      
      let timeZone = TimeZone(secondsFromGMT: 0)
      let calendar = Calendar(identifier: .gregorian)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 10, day: 30, hour: 10, minute: 11, second: 47)
      let date = calendar.date(from: components)!
      XCTAssertDateEqual(user.createdAt, date)
      
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetCurrentUser() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements[0])
      let user = elements[0]!
      XCTAssertEqual(user.id, 1)
      XCTAssertEqual(user.username, "root")
      XCTAssertEqual(user.name, "Administrator")
      XCTAssertEqual(user.state, "active")
      XCTAssertEqual(user.avatarUrl, "https://www.gravatar.com/avatar/e64c7d89f26bd1972efa854d13d7dd61?s=80&d=identicon")
      XCTAssert(user.bio == nil)
      
      let timeZone = TimeZone(secondsFromGMT: 0)
      let calendar = Calendar(identifier: .gregorian)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 10, day: 30, hour: 10, minute: 11, second: 47)
      let date = calendar.date(from: components)!
      XCTAssertDateEqual(user.createdAt, date)
      
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetUsersStatus() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPutStatus() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetSSHKeys() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetUsersSSHKeys() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetSSHKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostSSHKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostSSHKeyForUser() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteSSHKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteUsersSSHKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetGPGKeys() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetGPGKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostGPGKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteGPGKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetUsersGPGKeys() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetGPGKeyForUser() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostUserGPGKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteUsersGPGKey() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetEmails() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetEmail() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostEmail() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteEmail() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostUsersEmail() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testDeleteUsersEmail() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testBlockUser() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testUnBlockUser() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetImpersonationTokens() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetUsersImpersonationToken() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostImpersonationToken() {
    let result = client.users.getCurrentUser()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      // asserts here
      XCTAssertEqual(true, true)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
}
