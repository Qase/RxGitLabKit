//
//  Namespace.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import Foundation

public struct Namespace: Codable {
  public let id: Int
  public let name, path, kind, fullPath: String
  
  enum CodingKeys: String, CodingKey {
    case id, name, path, kind
    case fullPath = "full_path"
  }
}
