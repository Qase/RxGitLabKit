//
//  AccessLevel.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

/// Access levels are defined on [GitLab Permissions](https://docs.gitlab.com/ee/user/permissions.html) page.
public enum AccessLevel: Int {
  
  /// Has the least privileges
  case guest = 10
  case reporter = 20
  case developer = 30
  case maintainer = 40
  /// Has the most privileges
  case owner = 50
}
