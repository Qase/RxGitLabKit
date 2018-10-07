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
  
  func testCommitDecoding() {
    let commitData = """
  {
  "id": "6104942438c14ec7bd21c6cd5bd995272b3faff6",
  "short_id": "6104942438c",
  "title": "Sanitize for network graph",
  "author_name": "randx",
  "author_email": "dmitriy.zaporozhets@gmail.com",
  "committer_name": "Dmitriy",
  "committer_email": "dmitriy.zaporozhets@gmail.com",
  "created_at": "2012-09-20T09:06:12+03:00",
  "message": "Sanitize for network graph",
  "committed_date": "2012-09-20T09:06:12+03:00",
  "authored_date": "2012-09-20T09:06:12+03:00",
  "parent_ids": [
    "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
  ],
  "last_pipeline" : {
    "id": 8,
    "ref": "master",
    "sha": "2dc6aa325a317eda67812f05600bdf0fcdc70ab0",
    "status": "created"
  },
  "stats": {
    "additions": 15,
    "deletions": 10,
    "total": 25
  },
  "status": "running"
  }
""".data()
    let decoder = JSONDecoder()
    guard let commit = try? decoder.decode(Commit.self, from: commitData) else {
      XCTFail("Failed to decode commit.")
      return
    }
    XCTAssertNotNil(commit.id)
    XCTAssertNotNil(commit.shortId)
    XCTAssertNotNil(commit.title)
    XCTAssertNotNil(commit.authorName)
    XCTAssertNotNil(commit.authorEmail)
    XCTAssertNotNil(commit.committerName)
    XCTAssertNotNil(commit.committerEmail)
    XCTAssertNotNil(commit.message)
    XCTAssertNotNil(commit.parentIds)
    XCTAssertNotNil(commit.lastPipeline)
    XCTAssertNotNil(commit.stats)
    XCTAssertNotNil(commit.status)
    XCTAssertNotNil(commit.authoredDate)
    XCTAssertNotNil(commit.committedDate)
    XCTAssertNotNil(commit.createdAt)
    print(commit)
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
