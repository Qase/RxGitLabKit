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
  
 
  private var client: RxGitLabAPIClient!
  
  private let hostURL = URL(string: "https://gitlab.fel.cvut.cz")!
  
  private let bag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    client = RxGitLabAPIClient(with: hostURL)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
}
