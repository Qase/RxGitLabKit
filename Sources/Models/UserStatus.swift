//
//  UserStatus.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation

public struct UserStatus: Codable {
  public let emoji, message, messageHTML: String

  enum CodingKeys: String, CodingKey {
    case emoji, message
    case messageHTML = "message_html"
  }
}
