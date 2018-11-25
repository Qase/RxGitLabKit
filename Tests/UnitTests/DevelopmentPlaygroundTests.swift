//
//  RxGitLabAPIClientTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 26/08/2018.
//

// THIS FILE IS JUST FOR DEVELOPMENT PURPOSES

import Foundation
import XCTest
import RxGitLabKit
import RxSwift
import RxTest
import RxBlocking

class DevelopmentPlaygroundTests: XCTestCase {

  var mockSession: MockURLSession!
  var client: HTTPClient!
  let mockProjectID = 8093

  private let hostURL = URL(string: "https://gitlab.fel.cvut.cz")!

  private let bag = DisposeBag()

  override func setUp() {
    mockSession = MockURLSession()
    client = HTTPClient(using: mockSession)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testDate() {
    let expectation = XCTestExpectation(description: "test")
    let httpURL = URL(string: "https://gitlab.com")!
    let httpTask = URLSession.shared.dataTask(with: httpURL) {
      (data, response, error) in
      guard let validData = data, let results = String(data: validData, encoding: .utf8), error == nil else {
        print("Error getting GitLab website")
        expectation.fulfill()
        return
      }
      print("Correctly read \(results.count) characters from GitLabs website HTML")
      expectation.fulfill()
    }
    httpTask.resume()
    wait(for: [expectation], timeout: 2)
  }

  func nextDataHandler(request: URLRequest) -> Data? {
    guard let url = request.url,
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
      let queryItems = components.queryItems,
      let _page = queryItems
        .filter({ $0.name == "page" })
        .first?
        .value
        .map({ Int($0) }),
      let page = _page,
      let _perPage = queryItems.filter({$0.name == "perPage"})
        .first?
        .value
        .map({Int($0)}),
      let perPage = _perPage
    else { return nil }
    let mocks: Data = PaginatorMocks.getCommitPage(page: page, perPage: perPage)

    return mocks
  }

  func testPaginator() {
    let perPage = 2
    mockSession.nextDataHandler = nextDataHandler

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    let hostCommunicator = HostCommunicator(network: client, hostURL: GeneralMocks.mockURL)
    let paginator = ArrayPaginator<Commit>(communicator: hostCommunicator, apiRequest: apiRequest, perPage: perPage)
    let result = paginator[2..<5]
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      commits.forEach { (commit) in
        print("\(commit.shortId!) \(commit.title!)")
      }
      print("Commit count: \(commits.count)")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }

  }

//
//  func testLoadAll() {
//
//
//    let mockSession = MultipleResponseMockURLSession(with: [
//      (nil, nil, HTTPURLResponse(url: GeneralMocks.mockURL, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: PaginatorMocks.getHeader(page: 1, perPage: 10))),
//      (PaginatorMocks.getCommitPage(page: 1, perPage: 10), nil, nil),
//      (PaginatorMocks.getCommitPage(page: 2, perPage: 10), nil, nil),
//      (PaginatorMocks.getCommitPage(page: 3, perPage: 10), nil, nil),
//      (PaginatorMocks.getCommitPage(page: 4, perPage: 10), nil, nil),
//      (PaginatorMocks.getCommitPage(page: 5, perPage: 10), nil, nil),
//      (PaginatorMocks.getCommitPage(page: 6, perPage: 10), nil, nil)])
//
//    cclient = HTTPClient(using: mockSession)
//
//    let client = HTTPClient(using: mockSession)
//    let apiRequest = APIRequest(path: "/projects/6798/repository/commits", method: .get)
//    let paginator = ArrayPaginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(nil), privateToken: Variable(""))
//
//    let expectation = XCTestExpectation(description: "result")
//    let bag = DisposeBag()
//
//
//    wait(for: [expectation], timeout: 2)
//  }

}
