//
//  Links.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import Foundation

public struct Links: Codable {
  public let linksSelf, issues, mergeRequests, repoBranches: String?
  public let labels, events, members: String?

  enum CodingKeys: String, CodingKey {
    case linksSelf = "self"
    case issues
    case mergeRequests = "merge_requests"
    case repoBranches = "repo_branches"
    case labels, events, members
  }
}
