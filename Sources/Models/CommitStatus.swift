//
//  CommitStatus.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

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

  public init(status: String? = nil, createdAt: Date? = nil, startedAt: Date? = nil, name: String? = nil, allowFailure: Bool? = nil, author: User? = nil, description: String? = nil, sha: String? = nil, targetURL: String? = nil, finishedAt: Date? = nil, id: Int? = nil, ref: String? = nil, coverage: Double? = nil) {
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
}
