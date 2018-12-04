//
//  Contributor.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation

public struct Contributor: Codable {
  public let name: String
  public let email: String
  public let commits: Int
  public let additions: Int
  public let deletions: Int
}
