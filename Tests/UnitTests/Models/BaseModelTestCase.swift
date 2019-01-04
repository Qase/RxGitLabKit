//
//  BaseModelTestCase.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/01/2019.
//

import Foundation
import XCTest
import RxGitLabKit

class BaseModelTestCase: XCTestCase {
  
  internal let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601full)
    return decoder
  }()
  
  internal let calendar = Calendar(identifier: .gregorian)
}
