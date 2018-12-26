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
  
  public init(note: String? = nil, lineType: String? = nil, line: Int? = nil, createdAt: Date? = nil, author: User? = nil, path: String? = nil) {
    self.note = note
    self.lineType = lineType
    self.line = line
    self.createdAt = createdAt
    self.author = author
    self.path = path
  }
}
