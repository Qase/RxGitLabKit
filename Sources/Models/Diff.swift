//
//  Diff.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

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
