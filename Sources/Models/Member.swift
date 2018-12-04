//
//  Member.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public struct Member: Codable {
  public let id: Int
  public let username, name, state: String
  public let avatarURL: String?
  public let webURL: String?
  public let expiresAt: Date?
  public let accessLevel: Int

  enum CodingKeys: String, CodingKey {
    case id, username, name, state
    case avatarURL = "avatar_url"
    case webURL = "web_url"
    case expiresAt = "expires_at"
    case accessLevel = "access_level"
  }
}

extension Member {
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    username = try values.decode(String.self, forKey: .username)
    name = try values.decode(String.self, forKey: .name)
    state = try values.decode(String.self, forKey: .state)
    avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
    webURL = try values.decodeIfPresent(String.self, forKey: .webURL)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let _expiresAt = try values.decodeIfPresent(String.self, forKey: .expiresAt) {
      expiresAt = Date.from(string: _expiresAt, using: dateFormatter)
    } else {
      expiresAt = nil
    }
    accessLevel = try values.decode(Int.self, forKey: .accessLevel)
  }
}
