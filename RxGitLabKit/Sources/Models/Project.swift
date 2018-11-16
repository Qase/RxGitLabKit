//
//  Project.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 23/08/2018.
//

import Foundation

public struct Project: Codable {
  private var decoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }
  public let id: Int?
  public let description: String?
  public let defaultBranch, visibility, sshURLToRepo: String?
  public let httpURLToRepo: String?
  public let webURL: String?
  public let readmeURL: String?
  public let tagList: [String]?
  public let owner: User?
  public let name, nameWithNamespace, path, pathWithNamespace: String?
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
  public let forksCount, starCount: Int?
  public let runnersToken: String?
  public let publicJobs: Bool?
  public let sharedWithGroups: [String]?
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

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    description = try values.decodeIfPresent(String.self, forKey: .description)
    defaultBranch = try values.decodeIfPresent(String.self, forKey: .defaultBranch)
    visibility = try values.decodeIfPresent(String.self, forKey: .visibility)
    sshURLToRepo = try values.decodeIfPresent(String.self, forKey: .sshURLToRepo)
    httpURLToRepo = try values.decodeIfPresent(String.self, forKey: .httpURLToRepo)
    webURL = try values.decodeIfPresent(String.self, forKey: .webURL)
    readmeURL = try values.decodeIfPresent(String.self, forKey: .readmeURL)
    tagList = try values.decodeIfPresent([String].self, forKey: .tagList)
    owner = try values.decodeIfPresent(User.self, forKey: .owner)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    nameWithNamespace = try values.decodeIfPresent(String.self, forKey: .nameWithNamespace)
    path = try values.decodeIfPresent(String.self, forKey: .path)
    pathWithNamespace = try values.decodeIfPresent(String.self, forKey: .pathWithNamespace)
    issuesEnabled = try values.decodeIfPresent(Bool.self, forKey: .issuesEnabled)
    openIssuesCount = try values.decodeIfPresent(Int.self, forKey: .openIssuesCount)
    mergeRequestsEnabled = try values.decodeIfPresent(Bool.self, forKey: .mergeRequestsEnabled)
    jobsEnabled = try values.decodeIfPresent(Bool.self, forKey: .jobsEnabled)
    wikiEnabled = try values.decodeIfPresent(Bool.self, forKey: .wikiEnabled)
    snippetsEnabled = try values.decodeIfPresent(Bool.self, forKey: .snippetsEnabled)
    resolveOutdatedDiffDiscussions = try values.decodeIfPresent(Bool.self, forKey: .resolveOutdatedDiffDiscussions)
    containerRegistryEnabled = try values.decodeIfPresent(Bool.self, forKey: .containerRegistryEnabled)
    createdAt = try Project.decodeDateIfPresent(values: values, forKey: .createdAt)
    lastActivityAt = try Project.decodeDateIfPresent(values: values, forKey: .lastActivityAt)
    creatorID = try values.decodeIfPresent(Int.self, forKey: .creatorID)
    namespace = try values.decodeIfPresent(Namespace.self, forKey: .namespace)
    importStatus = try values.decodeIfPresent(String.self, forKey: .importStatus)
    archived = try values.decodeIfPresent(Bool.self, forKey: .archived)
    avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
    sharedRunnersEnabled = try values.decodeIfPresent(Bool.self, forKey: .sharedRunnersEnabled)
    forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
    starCount = try values.decodeIfPresent(Int.self, forKey: .starCount)
    runnersToken = try values.decodeIfPresent(String.self, forKey: .runnersToken)
    publicJobs = try values.decodeIfPresent(Bool.self, forKey: .publicJobs)
    sharedWithGroups = try values.decodeIfPresent([String].self, forKey: .sharedWithGroups)
    onlyAllowMergeIfPipelineSucceeds = try values.decodeIfPresent(Bool.self, forKey: .onlyAllowMergeIfPipelineSucceeds)
    onlyAllowMergeIfAllDiscussionsAreResolved = try values.decodeIfPresent(Bool.self, forKey: .onlyAllowMergeIfAllDiscussionsAreResolved)
    requestAccessEnabled = try values.decodeIfPresent(Bool.self, forKey: .requestAccessEnabled)
    mergeMethod = try values.decodeIfPresent(String.self, forKey: .mergeMethod)
    statistics = try values.decodeIfPresent(ProjectStatistics.self, forKey: .statistics)
    links = try values.decodeIfPresent(Links.self, forKey: .links)
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
