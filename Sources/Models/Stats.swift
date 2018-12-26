//
//  Stats.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public struct Stats: Codable, Equatable {
  public let additions: Int?
  public let deletions: Int?
  public let total: Int?
  
  public init(additions: Int?, deletions: Int?, total: Int?) {
    self.additions = additions
    self.deletions = deletions
    self.total = total
  }
}
