//
//  Token.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation

struct Authentication: Codable {
  let accessToken: String?
  let tokenType: String?
  let refreshToken: String?
  let scope: String?
  let createdAt: Int?
  var createdAtDate: Date? {
    if let createdAt = createdAt {
      return Date(timeIntervalSince1970: TimeInterval(createdAt))
    }
    return nil
  }
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
    case refreshToken = "refresh_token"
    case scope = "scope"
    case createdAt = "created_at"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
    tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
    refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
    scope = try values.decodeIfPresent(String.self, forKey: .scope)
    createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
  }
}
