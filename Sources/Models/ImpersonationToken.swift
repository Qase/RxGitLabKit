//
//  ImpersonationToken.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation

public struct ImpersonationToken: Codable {
  public let id: Int?
  public let active: Bool?
  public let token: String?
  public let scopes: [String]?
  public let revoked: Bool?
  public let name: String?
  public let createdAt: Date?
  public let impersonation: Bool?
  public let expiresAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case active, token, scopes, revoked, name, id
    case createdAt = "created_at"
    case impersonation
    case expiresAt = "expires_at"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    active = try values.decodeIfPresent(Bool.self, forKey: .active)
    token = try values.decodeIfPresent(String.self, forKey: .token)
    scopes = try values.decodeIfPresent([String].self, forKey: .scopes)
    revoked = try values.decodeIfPresent(Bool.self, forKey: .revoked)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    createdAt = try ImpersonationToken.decodeDateIfPresent(values: values, forKey: .createdAt)
    impersonation = try values.decodeIfPresent(Bool.self, forKey: .impersonation)
    expiresAt = try ImpersonationToken.decodeDateDayIfPresent(values: values, forKey: .expiresAt)
  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = DateFormatter.iso8601full
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }
  
  private static func decodeDateDayIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = DateFormatter.yyyyMMdd
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }
}
