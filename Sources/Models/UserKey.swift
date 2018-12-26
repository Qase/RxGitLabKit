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
  
  public init(id: Int? = nil, title: String? = nil, key: String? = nil, createdAt: Date? = nil) {
    self.id = id
    self.title = title
    self.key = key
    self.createdAt = createdAt
  }
}
