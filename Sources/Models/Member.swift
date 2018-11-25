//
//  Member.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public struct Member: Codable {
  let id: Int
  let username, name, state: String
  let avatarURL: String
  let webURL: String
  let expiresAt: Date
  let accessLevel: Int

  enum CodingKeys: String, CodingKey {
    case id, username, name, state
    case avatarURL = "avatar_url"
    case webURL = "web_url"
    case expiresAt = "expires_at"
    case accessLevel = "access_level"
  }
}
