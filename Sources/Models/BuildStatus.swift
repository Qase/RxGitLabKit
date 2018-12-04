//
//  BuildStatus.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/12/2018.
//

import Foundation

public struct BuildStatus: Codable {
  public let state: String
  public let ref: String?
  public let name: String?
  public let targetURL: String?
  public let description: String?
  public let coverage: Double?
  
  enum CodingKeys: String, CodingKey {
    case state
    case ref
    case name
    case targetURL = "target_url"
    case description
    case coverage
  }
  
  public enum State: String {
    case pending, running, success, failed, canceled
  }
}
