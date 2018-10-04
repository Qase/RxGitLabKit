//
//  AccessLevel.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public enum AccessLevel: Int {
  case guest = 10
  case reporter = 20
  case developer = 30
  case maintainer = 40
  case owner = 50
}
