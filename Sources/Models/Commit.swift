//
//  Commit.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation

public struct Commit: Codable, Equatable {
  public static func == (lhs: Commit, rhs: Commit) -> Bool {
    return lhs.id == rhs.id &&
      lhs.shortId == rhs.shortId &&
      lhs.title == rhs.title &&
      lhs.authorName == rhs.authorName &&
      lhs.authorEmail == rhs.authorEmail &&
      lhs.authoredDate == rhs.authoredDate &&
      lhs.committerName == rhs.committerName &&
      lhs.committerEmail == rhs.committerEmail &&
      lhs.committedDate == rhs.committedDate &&
      lhs.createdAt == rhs.createdAt &&
      lhs.message == rhs.message &&
      lhs.parentIds == rhs.parentIds &&
      lhs.lastPipeline == rhs.lastPipeline &&
      lhs.stats == rhs.stats &&
      lhs.status == rhs.status
  }

  public let id: String
  public let shortId: String
  public let title: String?
  public let authorName: String
  public let authorEmail: String?
  public let authoredDate: Date?
  public let committerName: String
  public let committerEmail: String
  public let committedDate: Date?
  public let createdAt: Date?
  public let message: String?
  public let parentIds: [String]?
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
    id = try values.decode(String.self, forKey: .id)
    shortId = try values.decode(String.self, forKey: .shortId)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    authorName = try values.decode(String.self, forKey: .authorName)
    authorEmail = try values.decodeIfPresent(String.self, forKey: .authorEmail)
    committerName = try values.decode(String.self, forKey: .committerName)
    committerEmail = try values.decode(String.self, forKey: .committerEmail)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    parentIds = try values.decodeIfPresent([String].self, forKey: .parentIds)
    lastPipeline = try values.decodeIfPresent(LastPipeline.self, forKey: .lastPipeline)
    stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
    status = try values.decodeIfPresent(String.self, forKey: .status)
    authoredDate = try Commit.decodeDateIfPresent(values: values, forKey: .authoredDate)
    committedDate = try Commit.decodeDateIfPresent(values: values, forKey: .committedDate)
    createdAt = try Commit.decodeDateIfPresent(values: values, forKey: .createdAt)
  }

  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }
}

public struct NewCommit: Codable, Equatable {
  public let branch: String
  public let commitMessage: String
  public let startBranch: String?
  public let actions: [Action]
  public let authorEmail: String?
  public let authorName: String?
  public let stats: Bool?

  enum CodingKeys: String, CodingKey {
    case branch
    case commitMessage = "commit_message"
    case startBranch = "start_branch"
    case actions
    case authorEmail = "author_email"
    case authorName = "author_name"
    case stats
  }

  public init(branch: String, commitMessage: String, startBranch: String? = nil, actions: [Action], authorEmail: String? = nil, authorName: String? = nil, stats: Bool? = nil) {
    self.branch = branch
    self.commitMessage = commitMessage
    self.startBranch = startBranch
    self.actions = actions
    self.authorEmail = authorEmail
    self.authorName = authorName
    self.stats = stats
  }

  public static func == (lhs: NewCommit, rhs: NewCommit) -> Bool {
    return lhs.branch == rhs.branch &&
      lhs.commitMessage == rhs.commitMessage &&
      lhs.startBranch == rhs.startBranch &&
      lhs.actions == rhs.actions &&
      lhs.authorEmail == rhs.authorEmail &&
      lhs.authorName == rhs.authorName &&
      lhs.stats == rhs.stats
  }
}
