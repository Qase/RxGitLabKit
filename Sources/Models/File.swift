//
//  File.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/12/2018.
//

import Foundation

public struct File: Codable {
  /// Url encoded full path to new file. Ex. lib%2Fclass%2Erb (**required** when `POST`, `PUT` or `DELETE`)
  public let filePath: String?
  
  /// Name of the branch (**required** when `POST`, `PUT` or `DELETE`)
  public let branch: String?
  
  /// Name of the branch to start the new commit from
  public let startBranch: String?
  
  /// Change encoding to ‘base64’. Default is text.
  public let encoding: String?
  
  /// Specify the commit author’s email address
  public let authorEmail: String?
  
  /// Specify the commit author’s name
  public let authorName: String?
  
  /// File content (**required** when `POST`, `PUT` or `DELETE`)
  public let content: String?
  
  /// Commit message (**required** when `POST`, `PUT` or `DELETE`)
  public let commitMessage: String?
  
  /// Last known file commit id
  public let lastCommitID: String?
  
  enum CodingKeys: String, CodingKey {
    case filePath = "file_path"
    case branch
    case startBranch = "start_branch"
    case encoding
    case authorEmail = "author_email"
    case authorName = "author_name"
    case content
    case commitMessage = "commit_message"
    case lastCommitID = "last_commit_id"
  }
}
