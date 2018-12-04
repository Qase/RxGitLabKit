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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testStatus() {
    let emoji = "airplane_arriving"
    let message = "Back from vacation."
    let status = UserStatus(emoji: emoji, message: message, messageHTML: nil)
    let putResult = client.users.putStatus(status: status)
      .toBlocking()
      .materialize()
    switch putResult {
    case .completed(elements: let elements):
      guard let status = elements.first else {
        XCTFail("Status not received.")
        return
      }
      XCTAssertEqual(status.emoji, emoji)
      XCTAssertEqual(status.message, message)
      XCTAssertEqual(status.messageHTML, message)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    
    let result = client.users.getStatus()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let status = elements.first else {
        XCTFail("Status not received.")
        return
      }
      XCTAssertEqual(status.emoji, emoji)
      XCTAssertEqual(status.message, message)
      XCTAssertEqual(status.messageHTML, message)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testUsersStatus() {
    let emoji = "coffee"
    let message = "Coffee time."
    
    let result = client.users.getUsersStatus(userID: 10)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let status = elements.first else {
        XCTFail("Status not received.")
        return
      }
      XCTAssertEqual(status.emoji, emoji)
      XCTAssertEqual(status.message, message)
      XCTAssertEqual(status.messageHTML, message)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }

  func testGetSSHKeys() {
    let result = client.users.getSSHKeys()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let keys = elements.first else {
        XCTFail("Keys not received.")
        return
      }
      XCTAssertEqual(keys.count, 0)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetUsersSSHKeys() {
    let result = client.users.getUsersSSHKeys(userID: 4)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let keys = elements.first else {
        XCTFail("Keys not received.")
        return
      }
      XCTAssertEqual(keys.count, 1)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetEmails() {
    let result = client.users.getEmails()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let emails = elements.first else {
        XCTFail("Emails not received.")
        return
      }
      XCTAssertEqual(emails.count, 2)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetEmail() {
    let result = client.users.getEmail(emailID: 6)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let email = elements.first else {
        XCTFail("Email not received.")
        return
      }
      XCTAssertEqual(email.email, "email2@example.com")
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testPostAndDeleteEmail() {
    let emailString = "email10@examole.com"
    var newEmail = Email(id: nil, email: emailString)
    let postResult = client.users.postEmail(email: newEmail)
      .toBlocking()
      .materialize()
    switch postResult {
    case .completed(elements: let elements):
      guard let email = elements.first else {
        XCTFail("Email not received.")
        return
      }
      newEmail = email
      XCTAssertEqual(email.email, emailString)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    guard let newEmailID = newEmail.id else {
      XCTFail("Email has no id.")
      return
    }
    let deleteResult = client.users.deleteEmail(emailID: newEmailID)
      .toBlocking()
      .materialize()
    switch deleteResult {
    case .completed(elements: let elements):
      guard let success = elements.first else {
        XCTFail("Email not received.")
        return
      }
     XCTAssertTrue(success)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testPostAndDeleteUsersEmail() {
    let emailString = "email10@examole.com"
    var newEmail = Email(id: nil, email: emailString)
    let postResult = client.users.postUsersEmail(email: newEmail, userID: 10)
      .toBlocking()
      .materialize()
    switch postResult {
    case .completed(elements: let elements):
      guard let email = elements.first else {
        XCTFail("Email not received.")
        return
      }
      newEmail = email
      XCTAssertEqual(email.email, emailString)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    guard let newEmailID = newEmail.id else {
      XCTFail("Email has no id.")
      return
    }
    let deleteResult = client.users.deleteUsersEmail(userID: 10, emailID: newEmailID)
      .toBlocking()
      .materialize()
    switch deleteResult {
    case .completed(elements: let elements):
      guard let success = elements.first else {
        XCTFail("No response received.")
        return
      }
      XCTAssertTrue(success)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testBlockAndUnblockUser() {
    let result = client.users.blockUser(userID: 11)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let success = elements.first else {
        XCTFail("No response received.")
        return
      }
      XCTAssertTrue(success)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    
    let unblockResult = client.users.unBlockUser(userID: 11)
      .toBlocking()
      .materialize()
    
    switch unblockResult {
    case .completed(elements: let elements):
      guard let success = elements.first else {
        XCTFail("No response received.")
        return
      }
      XCTAssertTrue(success)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
}
