//
//  Token.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation

public struct Authentication: Codable {
  public let oAuthToken: String?
  public let tokenType: String?
  public let refreshToken: String?
  public let scope: String?
  public let createdAt: Int?
  public var createdAtDate: Date? {
    if let createdAt = createdAt {
      return Date(timeIntervalSince1970: TimeInterval(createdAt))
    }
    return nil
  }

  enum CodingKeys: String, CodingKey {
    case oAuthToken = "access_token"
    case tokenType = "token_type"
    case refreshToken = "refresh_token"
    case scope = "scope"
    case createdAt = "created_at"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    oAuthToken = try values.decodeIfPresent(String.self, forKey: .oAuthToken)
    tokenType = try values.decodeIfPresent(String.self, forKey: .tokenType)
    refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
    scope = try values.decodeIfPresent(String.self, forKey: .scope)
    createdAt = try values.decodeIfPresent(Int.self, forKey: .createdAt)
  }
}
