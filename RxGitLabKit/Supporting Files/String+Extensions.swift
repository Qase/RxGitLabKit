//
//  String+Extensions.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 20/08/2018.
//

import Foundation

extension String {
  
  
  /// Returns a Data containing a representation of the String encoded using UTF8.
  ///
  /// - Returns: Data?
  func data() -> Data {
    guard let data = data(using: .utf8) else { return Data() }
    return data
  }
}
