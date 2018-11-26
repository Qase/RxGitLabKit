//
//  PaginatorTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 24/10/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class PaginatorUnitTests: XCTestCase {

  let mockProjectID = 8093

  func testMockRange() {
    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: 1, perPage: 5)!, 0..<5)
    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: -1, perPage: 5)!, 0..<5)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 11, page: 3, perPage: 5)!, 10..<11)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: 3, perPage: 3)!, 6..<9)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 20, page: 3, perPage: 5)!, 10..<15)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 21, page: 5, perPage: 5)!, 20..<21)
    XCTAssertNil(PaginatorMocks.getPageRange(totalCount: 20, page: 5, perPage: 5))
  }

 
  func testLoadAll() {
    let mockSession = MultipleResponseMockURLSession(with: [
      (nil, nil, HTTPURLResponse(url: GeneralMocks.mockURL, statusCode: 200, httpVersion: "HTTP 1.1", headerFields: PaginatorMocks.getHeader(page: 1, perPage: 10))),
      (PaginatorMocks.getCommitPage(page: 1, perPage: 10), nil, nil),
      (PaginatorMocks.getCommitPage(page: 2, perPage: 10), nil, nil),
      (PaginatorMocks.getCommitPage(page: 3, perPage: 10), nil, nil),
      (PaginatorMocks.getCommitPage(page: 4, perPage: 10), nil, nil),
      (PaginatorMocks.getCommitPage(page: 5, perPage: 10), nil, nil),
      (PaginatorMocks.getCommitPage(page: 6, perPage: 10), nil, nil)])

    let client = HTTPClient(using: mockSession)
    let hostCommunicator = HostCommunicator(network: client, hostURL: GeneralMocks.mockURL)
    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    let paginator = Paginator<Commit>(communicator: hostCommunicator, apiRequest: apiRequest)

    let expectation = XCTestExpectation(description: "result")
    let bag = DisposeBag()
    paginator.loadAll()
      .subscribe(onNext: { commits in
        XCTAssertEqual(commits.count, PaginatorMocks.totalElementsCount)
        expectation.fulfill()
      }, onError: { error in
        expectation.fulfill()
        XCTFail(error.localizedDescription)
      })
    .disposed(by: bag)

    wait(for: [expectation], timeout: 2)
  }
}
