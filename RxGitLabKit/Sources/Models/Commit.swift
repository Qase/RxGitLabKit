//
//  Commit.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation

public struct Commit: Codable {
  public let id : String?
  public let shortId : String?
  public let title : String?
  public let authorName : String?
  public let authorEmail : String?
  public let authoredDate : String?
  public let committerName : String?
  public let committerEmail : String?
  public let committedDate : String?
  public let createdAt : String?
  public let message : String?
  public let parentIds : [String]?
  public let lastPipeline: LastPipeline?
  public let stats: Stats?
  public let status: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case shortId = "short_id"
    case title
    case authorName = "author_name"
    case authorEmail = "author_email"
    case authoredDate = "authored_date"
    case committerName = "committer_name"
    case committerEmail = "committer_email"
    case committedDate = "committed_date"
    case createdAt = "created_at"
    case message
    case parentIds = "parent_ids"
    case lastPipeline = "last_pipeline"
    case stats
    case status
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id)
    shortId = try values.decodeIfPresent(String.self, forKey: .shortId)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
    authorEmail = try values.decodeIfPresent(String.self, forKey: .authorEmail)
    authoredDate = try values.decodeIfPresent(String.self, forKey: .authoredDate)
    committerName = try values.decodeIfPresent(String.self, forKey: .committerName)
    committerEmail = try values.decodeIfPresent(String.self, forKey: .committerEmail)
    committedDate = try values.decodeIfPresent(String.self, forKey: .committedDate)
    createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    parentIds = try values.decodeIfPresent([String].self, forKey: .parentIds)
    lastPipeline = try values.decodeIfPresent(LastPipeline.self, forKey: .lastPipeline)
    stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
    status = try values.decodeIfPresent(String.self, forKey: .status)
  }
  
}

public struct NewCommit: Codable {
  public let id: String?
  public let branch: String
  public let commitMessage: String
  public let startBranch: String?
  public let actions: [Action]?
  public let authorEmail: String?
  public let authorName: String?
  public let stats: Bool?
  
  enum CodingKeys: String, CodingKey {
    case id
    case branch
    case commitMessage = "commit_message"
    case startBranch = "start_branch"
    case actions
    case authorEmail = "author_email"
    case authorName = "author_name"
    case stats
  }
}

public struct Action: Codable {
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
    case executeFileMode  = "execute_file_mode"
  }
  
  
}
