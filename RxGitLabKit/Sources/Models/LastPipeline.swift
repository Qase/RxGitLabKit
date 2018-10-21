//
//  LastPipeline.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/10/2018.
//

import Foundation

public struct LastPipeline: Codable, Equatable {
  public let id: Int?
  public let ref: String?
  public let sha: String?
  public let status: String?
  
  public init(id: Int?, ref: String?, sha: String?, status: String?) {
    self.id = id
    self.ref = ref
    self.sha = sha
    self.status = status
  }
}
