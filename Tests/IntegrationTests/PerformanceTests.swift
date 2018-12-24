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
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      let commitsPaginator = self.client.commits.getCommits(projectID: 7, perPage: 100)
      let result = commitsPaginator[1...40]
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        print(elements.first?.count ?? 0)
      case .failed(elements: _, error: let error):
        XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
      }
    }
  }
  
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
