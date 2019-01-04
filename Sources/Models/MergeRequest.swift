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
  public let mergedAt: Date?
  public let mergedBy: User?
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
    case mergedAt = "merged_at"
    case mergedBy = "merged_by"
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
}
