//
//  Commit.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation

struct Commit: Codable {
  let id : String?
  let shortId : String?
  let title : String?
  let authorName : String?
  let authorEmail : String?
  let authoredDate : String?
  let committerName : String?
  let committerEmail : String?
  let committedDate : String?
  let createdAt : String?
  let message : String?
  let parentIds : [String]?
  
  enum CodingKeys: String, CodingKey {
    
    case id = "id"
    case shortId = "short_id"
    case title = "title"
    case authorName = "author_name"
    case authorEmail = "author_email"
    case authoredDate = "authored_date"
    case committerName = "committer_name"
    case committerEmail = "committer_email"
    case committedDate = "committed_date"
    case createdAt = "created_at"
    case message = "message"
    case parentIds = "parent_ids"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id)
    shortId = try values.decodeIfPresent(String.self, forKey: .shortId)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
    authorEmail = try values.decodeIfPresent(String.self, forKey: .authorEmail)
    authoredDate = try values.decodeIfPresent(String.self, forKey: .authoredDate)
    committerName = try values.decodeIfPresent(String.self, forKey: .committerName)
    committerEmail = try values.decodeIfPresent(String.self, forKey: .committerEmail)
    committedDate = try values.decodeIfPresent(String.self, forKey: .committedDate)
    createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    parentIds = try values.decodeIfPresent([String].self, forKey: .parentIds)
  }
  
}
