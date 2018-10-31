//
//  UserKey.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation

public struct UserKey: Codable {
  public let id: Int?
  public let title, key: String?
  public let createdAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case id, title, key
    case createdAt = "created_at"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    key = try values.decodeIfPresent(String.self, forKey: .key)
    createdAt = try UserKey.decodeDateIfPresent(values: values, forKey: .createdAt)
  }
  
  public init(id: Int? = nil, title: String? = nil, key: String? = nil, createdAt: Date? = nil) {
    self.id = id
    self.title = title
    self.key = key
    self.createdAt = createdAt
  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}
