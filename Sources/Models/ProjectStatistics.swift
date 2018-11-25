//
//  ProjectStatistics.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import Foundation

public struct ProjectStatistics: Codable {
  public let commitCount, storageSize, repositorySize, lfsObjectsSize: Int
  public let jobArtifactsSize: Int

  enum CodingKeys: String, CodingKey {
    case commitCount = "commit_count"
    case storageSize = "storage_size"
    case repositorySize = "repository_size"
    case lfsObjectsSize = "lfs_objects_size"
    case jobArtifactsSize = "job_artifacts_size"
  }
}
