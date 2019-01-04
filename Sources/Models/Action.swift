//
//  Action.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

public struct Action: Codable, Equatable {
  public let action: String
  public let filePath: String
  public let previousPath: String?
  public let content: String?
  public let encoding: String?
  public let lastCommitID: String?
  public let executeFileMode: Bool?
  
  enum CodingKeys: String, CodingKey {
    case action
    case filePath  = "file_path"
    case previousPath  = "previous_path"
    case content
    case encoding
    case lastCommitID  = "last_commit_id"
    case executeFileMode  = "execute_filemode"
  }
  
  public init(action: String, filePath: String, previousPath: String? = nil, content: String? = nil, encoding: String? = nil, lastCommitID: String? = nil, executeFileMode: Bool? = nil) {
    self.action = action
    self.filePath = filePath
    self.previousPath = previousPath
    self.content = content
    self.encoding = encoding
    self.lastCommitID = lastCommitID
    self.executeFileMode = executeFileMode
  }
  
  public static func == (lhs: Action, rhs: Action) -> Bool {
    return lhs.action == rhs.action &&
      lhs.filePath == rhs.filePath &&
      lhs.previousPath == rhs.previousPath &&
      lhs.content == rhs.content &&
      lhs.encoding == rhs.encoding &&
      lhs.lastCommitID == rhs.lastCommitID &&
      lhs.executeFileMode == rhs.executeFileMode
  }
}
