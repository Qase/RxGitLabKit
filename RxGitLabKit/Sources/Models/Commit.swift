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
  
  public let id : String
  public let shortId : String?
  public let title : String?
  public let authorName : String?
  public let authorEmail : String?
  public let authoredDate : Date?
  public let committerName : String?
  public let committerEmail : String?
  public let committedDate : Date?
  public let createdAt : Date?
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
    id = try values.decode(String.self, forKey: .id)
    shortId = try values.decodeIfPresent(String.self, forKey: .shortId)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
    authorEmail = try values.decodeIfPresent(String.self, forKey: .authorEmail)
    committerName = try values.decodeIfPresent(String.self, forKey: .committerName)
    committerEmail = try values.decodeIfPresent(String.self, forKey: .committerEmail)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    parentIds = try values.decodeIfPresent([String].self, forKey: .parentIds)
    lastPipeline = try values.decodeIfPresent(LastPipeline.self, forKey: .lastPipeline)
    stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
    status = try values.decodeIfPresent(String.self, forKey: .status)
    authoredDate = try Commit.decodeDateIfPresent(values: values, forKey: .authoredDate)
    committedDate = try Commit.decodeDateIfPresent(values: values, forKey: .committedDate)
    createdAt = try Commit.decodeDateIfPresent(values: values, forKey: .createdAt)
  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}

public struct NewCommit: Codable, Equatable {
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
  
  public init(id: String? = nil, branch: String, commitMessage: String, startBranch: String? = nil, actions: [Action]? = nil, authorEmail: String? = nil, authorName: String? = nil, stats: Bool? = nil) {
    self.id = id
    self.branch = branch
    self.commitMessage = commitMessage
    self.startBranch = startBranch
    self.actions = actions
    self.authorEmail = authorEmail
    self.authorName = authorName
    self.stats = stats
  }
  
  
  public static func == (lhs: NewCommit, rhs: NewCommit) -> Bool {
    return lhs.id == rhs.id &&
    lhs.branch == rhs.branch &&
    lhs.commitMessage == rhs.commitMessage &&
    lhs.startBranch == rhs.startBranch &&
    lhs.actions == rhs.actions &&
    lhs.authorEmail == rhs.authorEmail &&
    lhs.authorName == rhs.authorName &&
    lhs.stats == rhs.stats
  }
  
}

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

public struct Diff: Codable {
  public let diff: String?
  public let newPath: String?
  public let oldPath: String?
  public let aMode: String?
  public let bMode: String?
  public let newFile: Bool?
  public let renamedFile: Bool?
  public let deletedFile: Bool?
  
  enum CodingKeys: String, CodingKey {
    case diff
    case newPath = "new_path"
    case oldPath = "old_path"
    case aMode = "a_mode"
    case bMode = "b_mode"
    case newFile = "new_file"
    case renamedFile = "renamed_file"
    case deletedFile = "deleted_file"
  }
}

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
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    note = try values.decode(String.self, forKey: .note)
    lineType = try values.decodeIfPresent(String.self, forKey: .lineType)
    line = try values.decodeIfPresent(Int.self, forKey: .line)
    createdAt = try Comment.decodeDateIfPresent(values: values, forKey: .createdAt)
    path = try values.decodeIfPresent(String.self, forKey: .path)
    author = try values.decodeIfPresent(User.self, forKey: .author)
  }
  
  public init(note: String? = nil, lineType: String? = nil, line: Int? = nil, createdAt: Date? = nil, author: User? = nil, path: String? = nil) {
    self.note = note
    self.lineType = lineType
    self.line = line
    self.createdAt = createdAt
    self.author = author
    self.path = path
  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}

public struct Author: Codable {
  public let id: Int
  public let username: String?
  public let email: String?
  public let name: String?
  public let state: String?
  public let createdAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case id, username, email, name, state
    case createdAt = "created_at"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    username = try values.decodeIfPresent(String.self, forKey: .username)
    email = try values.decodeIfPresent(String.self, forKey: .email)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    state = try values.decodeIfPresent(String.self, forKey: .state)
    createdAt = try Author.decodeDateIfPresent(values: values, forKey: .createdAt)
  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}

public struct CommitStatus: Codable {
  public let status: String?
  public let createdAt: Date?
  public let startedAt: Date?
  public let name: String?
  public let allowFailure: Bool?
  public let author: User?
  public let description: String?
  public let sha: String?
  public let targetURL: String?
  public let finishedAt: Date?
  public let id: Int?
  public let ref: String?
  public let coverage: Double?
  
  enum CodingKeys: String, CodingKey {
    case status
    case createdAt = "created_at"
    case startedAt = "started_at"
    case name
    case allowFailure = "allow_failure"
    case author, description, sha
    case targetURL = "target_url"
    case finishedAt = "finished_at"
    case id, ref
    case coverage
  }
  
  public init(status: String? = nil,createdAt: Date? = nil,startedAt: Date? = nil,name: String? = nil,allowFailure: Bool? = nil,author: User? = nil,description: String? = nil,sha: String? = nil,targetURL: String? = nil,finishedAt: Date? = nil,id: Int? = nil,ref: String? = nil,coverage: Double? = nil) {
    self.status = status
    self.createdAt = createdAt
    self.startedAt = startedAt
    self.name = name
    self.allowFailure = allowFailure
    self.author = author
    self.description = description
    self.sha = sha
    self.targetURL = targetURL
    self.finishedAt = finishedAt
    self.id = id
    self.ref = ref
    self.coverage = coverage
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    status = try values.decodeIfPresent(String.self, forKey: .status)
    startedAt = try CommitStatus.decodeDateIfPresent(values: values, forKey: .startedAt)
    allowFailure = try values.decodeIfPresent(Bool.self, forKey: .allowFailure)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    author = try values.decodeIfPresent(User.self, forKey: .author)
    description = try values.decodeIfPresent(String.self, forKey: .description)
    sha = try values.decodeIfPresent(String.self, forKey: .sha)
    targetURL = try values.decodeIfPresent(String.self, forKey: .targetURL)
    finishedAt = try CommitStatus.decodeDateIfPresent(values: values, forKey: .finishedAt)
    ref = try values.decodeIfPresent(String.self, forKey: .ref)
    createdAt = try CommitStatus.decodeDateIfPresent(values: values, forKey: .createdAt)
    coverage = try values.decodeIfPresent(Double.self, forKey: .coverage)

  }
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}

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
  
  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date?  {
    let dateFormatter = DateFormatter.default
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}


public struct TimeStats: Codable {
  public let timeEstimate, totalTimeSpent: Int?
  public let humanTimeEstimate, humanTotalTimeSpent: Int?
  
  enum CodingKeys: String, CodingKey {
    case timeEstimate = "time_estimate"
    case totalTimeSpent = "total_time_spent"
    case humanTimeEstimate = "human_time_estimate"
    case humanTotalTimeSpent = "human_total_time_spent"
  }
}
