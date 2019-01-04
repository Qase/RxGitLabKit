//
//  PaginatorIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 01/10/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class PaginatorIntegrationTests: BaseIntegrationTestCase {
  
  func testLoadAll() {
    let paginator = client.users.getUsers(perPage: 5)
    let loadAllObservable = paginator.loadAll()
    let totalObservable = paginator.totalItems
    
    let totalResult = totalObservable
      .toBlocking()
      .materialize()
    
    var total = 0
    switch totalResult {
    case .completed(elements: let elements):
      total = elements[0]
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }

    let result = loadAllObservable
      .toBlocking()
      .materialize()
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements[0].count, total)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }

}
