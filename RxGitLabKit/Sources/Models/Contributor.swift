//
//  Contributor.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation

struct Contributor: Codable {
  let name: String
  let email: String
  let commits: Int
  let additions: Int
  let deletions: Int
}
