//
//  ParsingError.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public enum ParsingError: Error {
  case encoding(message: String?)
  case decoding(message: String?)
}
