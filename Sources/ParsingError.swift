//
//  ParsingError.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

/// Parsing error
public enum ParsingError: Error {
  
  /// Encoding error with message
  case encoding(message: String?)
  
  /// Decoding error with message
  case decoding(message: String?)
}
