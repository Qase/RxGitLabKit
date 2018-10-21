//
//  CommitsEndpointGroupTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 18/10/2018.
//

import XCTest
import RxGitLabKit
import RxSwift

class CommitsEndpointGroupMocks {
  
  static let mockProjectID = "12345"
  
  static let twoCommitsData = """
[
  {
    "id": "ed899a2f4b50b4370feeea94676502b42383c746",
    "short_id": "ed899a2f4b5",
    "title": "Replace sanitize with escape once",
    "author_name": "Dmitriy Zaporozhets",
    "author_email": "dzaporozhets@sphereconsultinginc.com",
    "authored_date": "2012-09-20T11:50:22+03:00",
    "committer_name": "Administrator",
    "committer_email": "admin@example.com",
    "committed_date": "2012-09-20T11:50:22+03:00",
    "created_at": "2012-09-20T11:50:22+03:00",
    "message": "Replace sanitize with escape once",
    "parent_ids": [
      "6104942438c14ec7bd21c6cd5bd995272b3faff6"
    ]
  },
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
    "parent_ids": [
      "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
    ]
  }
]
""".data()
  
  static let newCommitResponseData = """
{
  "id": "ed899a2f4b50b4370feeea94676502b42383c746",
  "short_id": "ed899a2f4b5",
  "title": "some commit message",
  "author_name": "Dmitriy Zaporozhets",
  "author_email": "dzaporozhets@sphereconsultinginc.com",
  "committer_name": "Dmitriy Zaporozhets",
  "committer_email": "dzaporozhets@sphereconsultinginc.com",
  "created_at": "2016-09-20T09:26:24.000-07:00",
  "message": "some commit message",
  "parent_ids": [
    "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
  ],
  "committed_date": "2016-09-20T09:26:24.000-07:00",
  "authored_date": "2016-09-20T09:26:24.000-07:00",
  "stats": {
    "additions": 2,
    "deletions": 2,
    "total": 4
  },
  "status": null
}
""".data()
  
  static let singleCommitResponseData = """
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
    "sha": "2dc6aa325a317eda67812f05600bdf0fcdc70ab0"
    "status": "created"
  }
  "stats": {
    "additions": 15,
    "deletions": 10,
    "total": 25
  },
  "status": "running"
}
""".data()
  
  static let referencesResponseData = """
[
  {"type": "branch", "name": "'test'"},
  {"type": "branch", "name": "add-balsamiq-file"},
  {"type": "branch", "name": "wip"},
  {"type": "tag", "name": "v1.1.0"}
 ]
""".data()
  
  static let cherryPickResponseData = """
{
  "id": "8b090c1b79a14f2bd9e8a738f717824ff53aebad",
  "short_id": "8b090c1b",
  "title": "Feature added",
  "author_name": "Dmitriy Zaporozhets",
  "author_email": "dmitriy.zaporozhets@gmail.com",
  "authored_date": "2016-12-12T20:10:39.000+01:00",
  "created_at": "2016-12-12T20:10:39.000+01:00",
  "committer_name": "Administrator",
  "committer_email": "admin@example.com",
  "committed_date": "2016-12-12T20:10:39.000+01:00",
  "title": "Feature added",
  "message": "Feature added\n\nSigned-off-by: Dmitriy Zaporozhets <dmitriy.zaporozhets@gmail.com>\n",
  "parent_ids": [
    "a738f717824ff53aebad8b090c1b79a14f2bd9e8"
  ]
}
""".data()
  
  
}

class CommitsEndpointGroupTests: XCTestCase {
  private var client: RxGitLabAPIClient!
  
  private let hostURL = URL(string: "https://gitlab.test.com")!
  private let mockSession = MockURLSession()
  
  private let bag = DisposeBag()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    let mockHTTPClient = HTTPClient(using: mockSession)
    client = RxGitLabAPIClient(with: hostURL, using: mockHTTPClient)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  ///
  func testGet() {
    mockSession.nextData = CommitsEndpointGroupMocks.twoCommitsData
    let expectation = XCTestExpectation(description: "response")
    let paginator = client.commits.get(projectID: CommitsEndpointGroupMocks.mockProjectID)
    paginator.loadPage()
      .filter{!$0.isEmpty}
      .subscribe ( onNext: { commits in
        XCTAssertEqual(commits.count, 2)
        XCTAssertEqual(commits[0].parentIds?.count, 1)
        XCTAssertEqual(commits[0].parentIds?.first!, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
        expectation.fulfill()
        })
      .disposed(by: bag)
    

    
    wait(for: [expectation], timeout: 5)
  }

  func testGetSingle() {
    mockSession.nextData = CommitsEndpointGroupMocks.singleCommitResponseData
    let expectation = XCTestExpectation(description: "response")
    let commit = client.commits.getSingle(projectID: CommitsEndpointGroupMocks.mockProjectID, sha: "ed899a2f4b50b4370feeea94676502b42383c746")
    commit.subscribe ( onNext: { commit in
      let calendar = Calendar(identifier: .gregorian)
      let components = DateComponents(calendar: calendar, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12)
      let date = calendar.date(from: components)!
      XCTAssertEqual(commit.authoredDate, date)
      XCTAssertEqual(commit.committedDate, date)
        expectation.fulfill()
      })
      .disposed(by: bag)
    
    wait(for: [expectation], timeout: 5)
  }
}
