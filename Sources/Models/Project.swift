//
//  Project.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 23/08/2018.
//

import Foundation

public struct Project: Codable {
  public let id: Int
  public let description: String?
  public let defaultBranch: String?
  public let visibility, sshURLToRepo: String?
  public let httpURLToRepo: String?
  public let webURL: String?
  public let readmeURL: String?
  public let tagList: [String]?
  public let owner: User?
  public let name, nameWithNamespace, path, pathWithNamespace: String
  public let issuesEnabled: Bool?
  public let openIssuesCount: Int?
  public let mergeRequestsEnabled, jobsEnabled, wikiEnabled, snippetsEnabled: Bool?
  public let resolveOutdatedDiffDiscussions, containerRegistryEnabled: Bool?
  public let createdAt, lastActivityAt: Date?
  public let creatorID: Int?
  public let namespace: Namespace?
  public let importStatus: String?
  public let archived: Bool?
  public let avatarURL: String?
  public let sharedRunnersEnabled: Bool?
  public let forksCount, starCount: Int
  public let runnersToken: String?
  public let publicJobs: Bool?
  public let sharedWithGroups: [ShareGroup]?
  public let onlyAllowMergeIfPipelineSucceeds, onlyAllowMergeIfAllDiscussionsAreResolved, requestAccessEnabled: Bool?
  public let mergeMethod: String?
  public let statistics: ProjectStatistics?
  public let links: Links?
  
  enum CodingKeys: String, CodingKey {
    case id, description
    case defaultBranch = "default_branch"
    case visibility
    case sshURLToRepo = "ssh_url_to_repo"
    case httpURLToRepo = "http_url_to_repo"
    case webURL = "web_url"
    case readmeURL = "readme_url"
    case tagList = "tag_list"
    case owner, name
    case nameWithNamespace = "name_with_namespace"
    case path
    case pathWithNamespace = "path_with_namespace"
    case issuesEnabled = "issues_enabled"
    case openIssuesCount = "open_issues_count"
    case mergeRequestsEnabled = "merge_requests_enabled"
    case jobsEnabled = "jobs_enabled"
    case wikiEnabled = "wiki_enabled"
    case snippetsEnabled = "snippets_enabled"
    case resolveOutdatedDiffDiscussions = "resolve_outdated_diff_discussions"
    case containerRegistryEnabled = "container_registry_enabled"
    case createdAt = "created_at"
    case lastActivityAt = "last_activity_at"
    case creatorID = "creator_id"
    case namespace
    case importStatus = "import_status"
    case archived
    case avatarURL = "avatar_url"
    case sharedRunnersEnabled = "shared_runners_enabled"
    case forksCount = "forks_count"
    case starCount = "star_count"
    case runnersToken = "runners_token"
    case publicJobs = "public_jobs"
    case sharedWithGroups = "shared_with_groups"
    case onlyAllowMergeIfPipelineSucceeds = "only_allow_merge_if_pipeline_succeeds"
    case onlyAllowMergeIfAllDiscussionsAreResolved = "only_allow_merge_if_all_discussions_are_resolved"
    case requestAccessEnabled = "request_access_enabled"
    case mergeMethod = "merge_method"
    case statistics
    case links = "_links"
  }
}
