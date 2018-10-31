//
//  Email.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 31/10/2018.
//

import Foundation

public struct Email: Codable, Equatable {
  public let id: Int?
  public let email: String?
  
  public init(id: Int?, email: String) {
    self.id = id
    self.email = email
  }
}
