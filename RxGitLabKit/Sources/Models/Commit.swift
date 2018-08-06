//
//  Commit.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation

struct Commit: Codable {
  let id : String?
  let short_id : String?
  let title : String?
  let author_name : String?
  let author_email : String?
  let authored_date : String?
  let committer_name : String?
  let committer_email : String?
  let committed_date : String?
  let created_at : String?
  let message : String?
  let parent_ids : [String]?
  
  enum CodingKeys: String, CodingKey {
    
    case id = "id"
    case short_id = "short_id"
    case title = "title"
    case author_name = "author_name"
    case author_email = "author_email"
    case authored_date = "authored_date"
    case committer_name = "committer_name"
    case committer_email = "committer_email"
    case committed_date = "committed_date"
    case created_at = "created_at"
    case message = "message"
    case parent_ids = "parent_ids"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(String.self, forKey: .id)
    short_id = try values.decodeIfPresent(String.self, forKey: .short_id)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    author_name = try values.decodeIfPresent(String.self, forKey: .author_name)
    author_email = try values.decodeIfPresent(String.self, forKey: .author_email)
    authored_date = try values.decodeIfPresent(String.self, forKey: .authored_date)
    committer_name = try values.decodeIfPresent(String.self, forKey: .committer_name)
    committer_email = try values.decodeIfPresent(String.self, forKey: .committer_email)
    committed_date = try values.decodeIfPresent(String.self, forKey: .committed_date)
    created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    parent_ids = try values.decodeIfPresent([String].self, forKey: .parent_ids)
  }
  
}
