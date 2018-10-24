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
  private var mockSession: MockURLSession!
  private let calendar = Calendar(identifier: .gregorian)
  private let bag = DisposeBag()
  
  override func setUp() {
    mockSession = MockURLSession()
    let mockHTTPClient = HTTPClient(using: mockSession)
    client = RxGitLabAPIClient(with: hostURL, using: mockHTTPClient)
  }
  
  override func tearDown() {
  }
  
  func testGetCommits() {
    let request = URLRequest(url: hostURL.appendingPathComponent("/projects/\(CommitsMocks.mockProjectID)/repository/commits"))
    mockSession.urlResponse = GeneralMocks.successHttpURLResponse(request: request)
    mockSession.nextData = CommitsMocks.twoCommitsData
    let paginator = client.commits.getCommits(projectID: CommitsMocks.mockProjectID)
    let result = paginator.loadPage()
      .filter{!$0.isEmpty}
      .toBlocking(timeout: 1)
      .materialize()
    
    XCTAssertNotNil(mockSession.lastRequest)
    XCTAssertNotNil(mockSession.lastRequest!.url)
    let url = hostURL.appendingPathComponent("\(RxGitLabAPIClient.apiVersionURLString)/projects/\(CommitsMocks.mockProjectID)/repository/commits")
    XCTAssertTrue(mockSession.lastRequest!.url!.absoluteString.contains(url.absoluteString))

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

  func testGetCommit() {
    mockSession.nextData = CommitsMocks.singleCommitResponseData
    let commit = client.commits.getCommit(projectID: CommitsMocks.mockProjectID, sha: "ed899a2f4b50b4370feeea94676502b42383c746")
    let result = commit.toBlocking(timeout: 1).materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let commit = element.first!
      XCTAssertEqual(commit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
      XCTAssertEqual(commit.shortId, "6104942438c")
      XCTAssertEqual(commit.title, "Sanitize for network graph")
      XCTAssertEqual(commit.authorName, "randx")
      XCTAssertEqual(commit.authorEmail, "dmitriy.zaporozhets@gmail.com")
      XCTAssertEqual(commit.committerName, "Dmitriy")
      XCTAssertEqual(commit.committerEmail, "dmitriy.zaporozhets@gmail.com")
      XCTAssertEqual(commit.message, "Sanitize for network graph")
      XCTAssertNotNil(commit.parentIds)
      XCTAssertEqual(commit.parentIds!.count, 1)
      XCTAssertEqual(commit.parentIds!.first!, "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba")
      XCTAssertEqual(commit.status, "running")
      
      XCTAssertNotNil(commit.lastPipeline)
      let pipeline = commit.lastPipeline!
      XCTAssertEqual(pipeline.id, 8)
      XCTAssertEqual(pipeline.ref, "master")
      XCTAssertEqual(pipeline.sha, "2dc6aa325a317eda67812f05600bdf0fcdc70ab0")
      XCTAssertEqual(pipeline.status, "created")
      
      XCTAssertNotNil(commit.stats)
      let stats = commit.stats!
      XCTAssertEqual(stats.additions, 15)
      XCTAssertEqual(stats.deletions, 10)
      XCTAssertEqual(stats.total, 25)
      
      let timeZone = TimeZone(secondsFromGMT: 3*3600)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12)
      let date = calendar.date(from: components)!
      
      XCTAssertEqual(commit.createdAt, date)
      XCTAssertEqual(commit.authoredDate, date)
      XCTAssertEqual(commit.committedDate, date)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testCreateCommit() {
    
  }
  
  func testGetReferences() {
    
  }
  
  func testCherryPick() {
    
  }
  
  func testGetComments() {
    
  }
  
  func testPostComment() {
    
  }
  
  func testGetStaatuses() {
    
  }
  
  func testPostStatus() {
    
  }
  
  func getMergeRequests() {
    
  }
  
  
}
