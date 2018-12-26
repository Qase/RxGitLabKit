//
//  ShareGroup.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 18/11/2018.
//

import Foundation

public struct ShareGroup: Codable {
  let groupID: Int
  let groupName: String
  let groupAccessLevel: Int
  let expiresAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case groupID = "group_id"
    case groupName = "group_name"
    case groupAccessLevel = "group_access_level"
    case expiresAt = "expires_at"
  }
}
