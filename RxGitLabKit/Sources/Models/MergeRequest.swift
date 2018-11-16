//
//  MergeRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

public struct MergeRequest: Codable {
  public let id, iid: Int?
  public let projectID: Int?
  public let title, description, state: String?
  public let createdAt: Date?
  public let updatedAt: Date?
  public let targetBranch, sourceBranch: String?
  public let upvotes, downvotes: Int?
  public let author: User?
  public let assignee: User?
  public let sourceProjectID, targetProjectID: Int?
  public let labels: [String]?
  public let workInProgress: Bool?
  public let milestone: String?
  public let mergeWhenPipelineSucceeds: Bool?
  public let mergeStatus, sha: String?
  public let mergeCommitSHA: String?
  public let userNotesCount: Int?
  public let discussionLocked, shouldRemoveSourceBranch: Bool?
  public let forceRemoveSourceBranch: Bool?
  public let webURL: String?
  public let timeStats: TimeStats?

  enum CodingKeys: String, CodingKey {
    case id, iid
    case projectID = "project_id"
    case title, description, state
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case targetBranch = "target_branch"
    case sourceBranch = "source_branch"
    case upvotes, downvotes, author, assignee
    case sourceProjectID = "source_project_id"
    case targetProjectID = "target_project_id"
    case labels
    case workInProgress = "work_in_progress"
    case milestone
    case mergeWhenPipelineSucceeds = "merge_when_pipeline_succeeds"
    case mergeStatus = "merge_status"
    case sha
    case mergeCommitSHA = "merge_commit_sha"
    case userNotesCount = "user_notes_count"
    case discussionLocked = "discussion_locked"
    case shouldRemoveSourceBranch = "should_remove_source_branch"
    case forceRemoveSourceBranch = "force_remove_source_branch"
    case webURL = "web_url"
    case timeStats = "time_stats"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    iid = try values.decodeIfPresent(Int.self, forKey: .iid)
    projectID = try values.decodeIfPresent(Int.self, forKey: .projectID)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    description = try values.decodeIfPresent(String.self, forKey: .description)
    state = try values.decodeIfPresent(String.self, forKey: .state)
    createdAt = try MergeRequest.decodeDateIfPresent(values: values, forKey: .createdAt)
    updatedAt = try MergeRequest.decodeDateIfPresent(values: values, forKey: .updatedAt)
    targetBranch = try values.decodeIfPresent(String.self, forKey: .targetBranch)
    sourceBranch = try values.decodeIfPresent(String.self, forKey: .sourceBranch)
    upvotes = try values.decodeIfPresent(Int.self, forKey: .upvotes)
    downvotes = try values.decodeIfPresent(Int.self, forKey: .downvotes)
    author = try values.decodeIfPresent(User.self, forKey: .author)
    assignee = try values.decodeIfPresent(User.self, forKey: .assignee)
    sourceProjectID = try values.decodeIfPresent(Int.self, forKey: .sourceProjectID)
    targetProjectID = try values.decodeIfPresent(Int.self, forKey: .targetProjectID)
    labels = try values.decodeIfPresent([String].self, forKey: .labels)
    workInProgress = try values.decodeIfPresent(Bool.self, forKey: .workInProgress)
    milestone = try values.decodeIfPresent(String.self, forKey: .milestone)
    mergeWhenPipelineSucceeds = try values.decodeIfPresent(Bool.self, forKey: .mergeWhenPipelineSucceeds)
    mergeStatus = try values.decodeIfPresent(String.self, forKey: .mergeStatus)
    sha = try values.decodeIfPresent(String.self, forKey: .sha)
    mergeCommitSHA = try values.decodeIfPresent(String.self, forKey: .mergeCommitSHA)
    userNotesCount = try values.decodeIfPresent(Int.self, forKey: .userNotesCount)
    discussionLocked = try values.decodeIfPresent(Bool.self, forKey: .discussionLocked)
    shouldRemoveSourceBranch = try values.decodeIfPresent(Bool.self, forKey: .shouldRemoveSourceBranch)
    forceRemoveSourceBranch = try values.decodeIfPresent(Bool.self, forKey: .forceRemoveSourceBranch)
    webURL = try values.decodeIfPresent(String.self, forKey: .webURL)
    timeStats = try values.decodeIfPresent(TimeStats.self, forKey: .timeStats)

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
