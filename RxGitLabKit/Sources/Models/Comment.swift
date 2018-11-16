//
//  Comment.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

public struct Comment: Codable {
  public let note: String?
  public let lineType: String?
  public let line: Int?
  public let createdAt: Date?
  public let author: User?
  public let path: String?

  enum CodingKeys: String, CodingKey {
    case note, path, line, author
    case lineType = "line_type"
    case createdAt = "created_at"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    note = try values.decode(String.self, forKey: .note)
    lineType = try values.decodeIfPresent(String.self, forKey: .lineType)
    line = try values.decodeIfPresent(Int.self, forKey: .line)
    createdAt = try Comment.decodeDateIfPresent(values: values, forKey: .createdAt)
    path = try values.decodeIfPresent(String.self, forKey: .path)
    author = try values.decodeIfPresent(User.self, forKey: .author)
  }

  public init(note: String? = nil, lineType: String? = nil, line: Int? = nil, createdAt: Date? = nil, author: User? = nil, path: String? = nil) {
    self.note = note
    self.lineType = lineType
    self.line = line
    self.createdAt = createdAt
    self.author = author
    self.path = path
  }

  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }
}
