//
//  PaginatorTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 24/10/2018.
//

import XCTest
import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class PaginatorUnitTests: XCTestCase {

  var paginator: Paginator<Commit>!
  var mockSession: MockURLSession!
  var client: HTTPClient!
  let mockProjectID = 8093

  override func setUp() {
    mockSession = MockURLSession()
    client = HTTPClient(using: mockSession)
  }

  func testMockRange() {
    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: 1, perPage: 5)!, 0..<5)
    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: -1, perPage: 5)!, 0..<5)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 11, page: 3, perPage: 5)!, 10..<11)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 10, page: 3, perPage: 3)!, 6..<9)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 20, page: 3, perPage: 5)!, 10..<15)

    XCTAssertEqual(PaginatorMocks.getPageRange(totalCount: 21, page: 5, perPage: 5)!, 20..<21)
    XCTAssertNil(PaginatorMocks.getPageRange(totalCount: 20, page: 5, perPage: 5))
  }

  func testLoadPageChangingState() {
    let page = 2
    let perPage = 13

    let defaultPage = 4
    let defaultPerPage = 20

    mockSession.nextData = PaginatorMocks.getCommitPage(page: page, perPage: perPage)

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))
    paginator.pageVariable.value = defaultPage
    paginator.perPageVariable.value = defaultPerPage
    let result = paginator.loadPage(page: page, perPage: perPage, isChangingState: true)
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      XCTAssertEqual(commits.count, perPage)
      XCTAssertEqual(paginator.pageVariable.value, page)
      XCTAssertEqual(paginator.perPageVariable.value, perPage)

      let mocks: [Commit] = PaginatorMocks.getCommitPage(page: page, perPage: perPage)
      for i in 0..<commits.count {
        XCTAssertEqual(commits[i], mocks[i])
      }

    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testLoadPageNotChangingState() {
    let page = 2
    let perPage = 13

    let defaultPage = 4
    let defaultPerPage = 20

    mockSession.nextData = PaginatorMocks.getCommitPage(page: page, perPage: perPage)

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))
    paginator.pageVariable.value = defaultPage
    paginator.perPageVariable.value = defaultPerPage
    let result = paginator.loadPage(page: page, perPage: perPage)
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      XCTAssertEqual(commits.count, perPage)
      XCTAssertEqual(paginator.pageVariable.value, defaultPage)
      XCTAssertEqual(paginator.perPageVariable.value, defaultPerPage)

      let mocks: [Commit] = PaginatorMocks.getCommitPage(page: page, perPage: perPage)
      for i in 0..<commits.count {
        XCTAssertEqual(commits[i], mocks[i])
      }

    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testLoadNextPage() {
    let page = 1
    let perPage = 7

    mockSession.nextData = PaginatorMocks.getCommitPage(page: page, perPage: perPage)

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))
    paginator.pageVariable.value = page
    paginator.perPageVariable.value = perPage
    let result = paginator.loadNextPage()
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      XCTAssertEqual(commits.count, perPage)
      XCTAssertEqual(paginator.pageVariable.value, page + 1)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testLoadPreviousPage() {
    let page = 2
    let perPage = 7

    mockSession.nextData = PaginatorMocks.getCommitPage(page: page - 1, perPage: perPage)

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))
    paginator.pageVariable.value = page
    paginator.perPageVariable.value = perPage
    let result = paginator.loadPreviousPage()
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      XCTAssertEqual(commits.count, perPage)
      let mocks: [Commit] = PaginatorMocks.getCommitPage(page: page - 1, perPage: perPage)
      for i in 0..<commits.count {
        XCTAssertEqual(commits[i], mocks[i])
      }

      XCTAssertEqual(paginator.pageVariable.value, page - 1)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

  func testLoadFirstPage() {
    let page = 2
    let perPage = 7

    mockSession.nextData = PaginatorMocks.getCommitPage(page: page - 1, perPage: perPage)

    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))
    paginator.pageVariable.value = page
    paginator.perPageVariable.value = perPage
    let result = paginator.loadFirstPage()
      .toBlocking()
      .materialize()

    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first)
      let commits = elements.first!
      XCTAssertEqual(commits.count, perPage)
      XCTAssertEqual(paginator.pageVariable.value, 1)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)

    }
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
    let apiRequest = APIRequest(path: "/projects/\(mockProjectID)/repository/commits", method: .get)
    paginator = Paginator(network: client, hostURL: GeneralMocks.mockURL, apiRequest: apiRequest, oAuthToken: Variable(""), privateToken: Variable(""))

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
