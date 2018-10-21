//
//  CommitsEndpointGroupTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 18/10/2018.
//

import XCTest
import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class CommitsEndpointGroupUnitTests: XCTestCase {
  private var client: RxGitLabAPIClient!
  
  private let hostURL = URL(string: "https://gitlab.test.com")!
  private let mockSession = MockURLSession()
  
  private let bag = DisposeBag()
  
  override func setUp() {
    let mockHTTPClient = HTTPClient(using: mockSession)
    client = RxGitLabAPIClient(with: hostURL, using: mockHTTPClient)
  }
  
  override func tearDown() {
  }
  

  func testGet() {
    mockSession.nextData = CommitsMocks.twoCommitsData
    let paginator = client.commits.get(projectID: CommitsMocks.mockProjectID)
    let result = paginator.loadPage()
      .filter{!$0.isEmpty}
      .toBlocking(timeout: 1)
      .materialize()

    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let commits = element.first!
      XCTAssertEqual(commits.count, 2)
      let firstCommit = commits.first!
      let secondCommit = commits.last!
      XCTAssertNotEqual(firstCommit, secondCommit)
      XCTAssertEqual(firstCommit.id, "ed899a2f4b50b4370feeea94676502b42383c746")
      XCTAssertEqual(firstCommit.shortId, "ed899a2f4b5")
      XCTAssertEqual(firstCommit.authorName, "Dmitriy Zaporozhets")

      
      
      
      
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testGetSingle() {
    mockSession.nextData = CommitsMocks.singleCommitResponseData
    let commit = client.commits.getSingle(projectID: CommitsMocks.mockProjectID, sha: "ed899a2f4b50b4370feeea94676502b42383c746")
    let result = commit.toBlocking(timeout: 1).materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let commit = element.first!
      XCTAssertEqual(commit.authorName, "randx")
      XCTAssertEqual(commit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
      XCTAssertEqual(commit.shortId, "6104942438c")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
    
    
//
//    mockSession.nextData = CommitsMocks.singleCommitResponseData
//    let expectation = XCTestExpectation(description: "response")
//    let commit = client.commits.getSingle(projectID: CommitsMocks.mockProjectID, sha: "ed899a2f4b50b4370feeea94676502b42383c746")
//    commit.subscribe ( onNext: { commit in
//      let calendar = Calendar(identifier: .gregorian)
//      let components = DateComponents(calendar: calendar, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12)
//      let date = calendar.date(from: components)!
//      XCTAssertEqual(commit.authoredDate, date)
//      XCTAssertEqual(commit.committedDate, date)
//        expectation.fulfill()
//    }, onError: { error in
//
//    })
//      .disposed(by: bag)
//
//    wait(for: [expectation], timeout: 5)
  }
}
