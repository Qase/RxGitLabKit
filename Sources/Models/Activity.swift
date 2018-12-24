//
//  Activity.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/12/2018.
//

import Foundation

public struct Activity: Codable {
  public let username: String
  public let lastActivityOn: Date?
  public let lastActivityAt: Date?
  
  enum CodingKeys: String, CodingKey {
    case username
    case lastActivityOn = "last_activity_on"
    case lastActivityAt = "last_activity_at"
  }
}

extension Activity {
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    username = try values.decode(String.self, forKey: .username)
    let dateFormatter = DateFormatter.yyyyMMdd
    if let _lastActivityOn = try values.decodeIfPresent(String.self, forKey: .lastActivityOn) {
      lastActivityOn = Date(from: _lastActivityOn, using: dateFormatter)
    } else {
      lastActivityOn = nil
    }
    if let _lastActivityAt = try values.decodeIfPresent(String.self, forKey: .lastActivityAt) {
      lastActivityAt = Date(from: _lastActivityAt, using: dateFormatter)
    } else {
      lastActivityAt = nil
    }
  }
}
