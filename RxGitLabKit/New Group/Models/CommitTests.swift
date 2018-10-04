//
//  CommitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 04/10/2018.
//

import XCTest
import RxGitLabKit

class CommitTests: XCTestCase {
  

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }
  
  func testDecoding() {
    let decoder = JSONDecoder()
    guard let newCommit = try? decoder.decode(NewCommit.self, from: ModelMocks.newCommitJSON.data()) else {
      XCTFail("Failed to decode new commit.")
      return
    }
    
    XCTAssertEqual(newCommit.branch, "master")
  }
  
  func testActionDecoding() {
    let mock = """
{
"action": "create",
"file_path": "foo/bar",
"content": "some content"
}
"""
    let decoder = JSONDecoder()
    guard let action = try? decoder.decode(Action.self, from: mock.data()) else {
      XCTFail("Failed to decode new action.")
      return
    }
    
  }

}
