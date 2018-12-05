//
//  FileInfo.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 17/11/2018.
//

import Foundation

public struct FileInfo: Codable {
  let fileName: String
  
  let filePath: String
  let size: Int
  let encoding, content, contentSha256, ref: String
  let blobID, commitID, lastCommitID: String
  
  enum CodingKeys: String, CodingKey {
    case fileName = "file_name"
    case filePath = "file_path"
    case size, encoding, content
    case contentSha256 = "content_sha256"
    case ref
    case blobID = "blob_id"
    case commitID = "commit_id"
    case lastCommitID = "last_commit_id"
  }
}

