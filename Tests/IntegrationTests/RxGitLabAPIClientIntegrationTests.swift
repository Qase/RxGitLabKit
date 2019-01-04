//
//  RxGitLabAPIClientIntegrationTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 20/08/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class RxGitLabAPIClientIntegrationTests: BaseIntegrationTestCase {
  
  func testLogin() {
    client.logOut()
    client.logIn(username: "root", password: "admin12345")
    let result = client.hostCommunicator.oAuthTokenVariable.asObservable()
      .filter{ $0 != nil }
      .take(1)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertNotNil(elements.first ?? nil)
      XCTAssertNil(client.privateToken)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
}
