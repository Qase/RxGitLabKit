//
//  PerformanceTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/12/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxTest
import RxBlocking

class PerformanceTests: BaseIntegrationTestCase {
  
  func testPerformancePerPage100() {
    var measurement = 1
    self.measure {
      print("Measurement: \(measurement)")
      measurement += 1
      let commitsPaginator = self.client.commits.getCommits(projectID: 3, perPage: 100)
      _ = commitsPaginator.loadAll()
        .toBlocking()
        .materialize()
    }
  }
  
  func testPerformancePerPage20() {
    var measurement = 1
    self.measure {
      print("Measurement: \(measurement)")
      measurement += 1
      let commitsPaginator = self.client.commits.getCommits(projectID: 3, perPage: 20)
      _ = commitsPaginator.loadAll()
        .toBlocking()
        .materialize()
    }
  }
}
