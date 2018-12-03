//
//  XCTest+Extensions.swift
//  RxGitLabKit-iOS
//
//  Created by Dagy Tran on 28/11/2018.
//

import XCTest

extension XCTestCase {
  func XCTAssertDateEqual(_ expected: Date?, _ actual: Date?) {
    XCTAssertEqual(Int(expected?.timeIntervalSinceReferenceDate ?? -1), Int(actual?.timeIntervalSinceReferenceDate ?? -1))
  }
}
