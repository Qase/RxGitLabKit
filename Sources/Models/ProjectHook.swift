//
//  Hook.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import Foundation

public struct ProjectHook: Codable {
  public let id: Int?
  public let url: String?
  public let projectID: Int?
  public let pushEvents: Bool?
  public let pushEventsBranchFilter: String?
  public let issuesEvents, confidentialIssuesEvents, mergeRequestsEvents, tagPushEvents: Bool?
  public let noteEvents, jobEvents, pipelineEvents, wikiPageEvents: Bool?
  public let enableSSLVerification: Bool?
  public let createdAt: Date?

  enum CodingKeys: String, CodingKey {
    case id, url
    case projectID = "project_id"
    case pushEvents = "push_events"
    case pushEventsBranchFilter = "push_events_branch_filter"
    case issuesEvents = "issues_events"
    case confidentialIssuesEvents = "confidential_issues_events"
    case mergeRequestsEvents = "merge_requests_events"
    case tagPushEvents = "tag_push_events"
    case noteEvents = "note_events"
    case jobEvents = "job_events"
    case pipelineEvents = "pipeline_events"
    case wikiPageEvents = "wiki_page_events"
    case enableSSLVerification = "enable_ssl_verification"
    case createdAt = "created_at"
  }
}
