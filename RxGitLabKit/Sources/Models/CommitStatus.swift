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
    let dateFormatter = ISO8601DateFormatter()
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString)  {
      return date
    } else {
      return nil
    }
  }
}
