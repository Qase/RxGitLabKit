//
//  RepositoriesEndpointGroupUnitTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 29/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class RepositoriesEndpointGroupUnitTests: EndpointGroupUnitTestCase {
  
  
  
  
  func testGetTree() {
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
  
  func testGetBlob() {
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
  
  func testGetBlobRaw() {
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
  
  func testGetArchive() {
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
  
  func testGetComparison() {
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
  
  func testGetContributors() {
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
  
  func testGetMergeBase() {
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
  
  func testGetFileInfo() {
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
  
  func testGetFile() {
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
  
  func testPostFile() {
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
  
  func testPutFile() {
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
  
  func testDeleteFile() {
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
