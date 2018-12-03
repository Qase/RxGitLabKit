//
//  ProjectsEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 27/11/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxAtomic
import RxBlocking
import RxTest

class ProjectsEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testGetLanguages() {
    let languages = client.projects.getLanguages(projectID: 4)
    let result = languages
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let languages = element.first!
      print(languages)
      XCTAssertNotNil(languages["Swift"])
      XCTAssertNotNil(languages["Ruby"])
      XCTAssertNotNil(languages["Objective-C"])
      XCTAssertEqual(languages["Swift"]!, 97.47)
      XCTAssertEqual(languages["Ruby"]!, 1.77)
      XCTAssertEqual(languages["Objective-C"]!, 0.76)
      
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  
  func testGetProjects() {
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
  
  func testGetProject() {
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
  
  func testGetUserProjects() {
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

  
  func testGetProjectUsers() {
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
  
  func testPostProject() {
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
  
  func testDeleteProject() {
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
  
  func testPostProjectForUser() {
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
  
  func testPutProject() {
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
  
  func testForkProject() {
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
  
  func testGetProjectForks() {
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
  
  func testStarProject() {
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
  
  func testUnstarProject() {
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
  
  func testArchiveProject() {
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
  
  func testUnarchiveProject() {
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
  
  func testShareProjectWithGroup() {
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
  
  func testDeleteSharedProjectWithinGroup() {
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
  
  func testGetHooks() {
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
  
  func testGetHook() {
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
  
  func testPostHook() {
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
  
  func testPutHook() {
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
  
  func testDeleteHook() {
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
  
  func testPostForkRelation() {
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
  
  func testDeleteForkRelation() {
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
  
  func testPostHousekeeping() {
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
  
  func testPutTransfer() {
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

