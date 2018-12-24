//
//  BaseIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 27/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class BaseIntegrationTestCase: XCTestCase {
  internal var client: RxGitLabAPIClient!
  internal var hostCommunicator: HostCommunicator!
  internal var disposeBag: DisposeBag!
  internal let hostURL = URL(string: "http://localhost:80")!
  internal let defaultTimeout = RxTimeInterval(exactly: 5)
  
  override func setUp() {
    super.setUp()
    hostCommunicator = HostCommunicator(hostURL: hostURL)
    client = RxGitLabAPIClient(with: hostURL, privateToken: "pxu4zszRBBoEe9bsybGc")
    disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    super.tearDown()
    disposeBag = nil
  }
}
