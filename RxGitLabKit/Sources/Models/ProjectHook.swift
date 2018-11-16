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

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    url = try values.decodeIfPresent(String.self, forKey: .url)
    projectID = try values.decodeIfPresent(Int.self, forKey: .projectID)
    pushEvents = try values.decodeIfPresent(Bool.self, forKey: .pushEvents)
    pushEventsBranchFilter = try values.decodeIfPresent(String.self, forKey: .pushEventsBranchFilter)
    issuesEvents = try values.decodeIfPresent(Bool.self, forKey: .issuesEvents)
    confidentialIssuesEvents = try values.decodeIfPresent(Bool.self, forKey: .confidentialIssuesEvents)
    mergeRequestsEvents = try values.decodeIfPresent(Bool.self, forKey: .mergeRequestsEvents)
    tagPushEvents = try values.decodeIfPresent(Bool.self, forKey: .tagPushEvents)
    noteEvents = try values.decodeIfPresent(Bool.self, forKey: .noteEvents)
    jobEvents = try values.decodeIfPresent(Bool.self, forKey: .jobEvents)
    pipelineEvents = try values.decodeIfPresent(Bool.self, forKey: .pipelineEvents)
    wikiPageEvents = try values.decodeIfPresent(Bool.self, forKey: .wikiPageEvents)
    enableSSLVerification = try values.decodeIfPresent(Bool.self, forKey: .enableSSLVerification)
    createdAt = try ProjectHook.decodeDateIfPresent(values: values, forKey: .createdAt)
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
