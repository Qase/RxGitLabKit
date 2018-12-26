//
//  TimeStats.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 05/11/2018.
//

import Foundation

public struct TimeStats: Codable {
  public let timeEstimate, totalTimeSpent: Int?
  public let humanTimeEstimate, humanTotalTimeSpent: Int?
  
  enum CodingKeys: String, CodingKey {
    case timeEstimate = "time_estimate"
    case totalTimeSpent = "total_time_spent"
    case humanTimeEstimate = "human_time_estimate"
    case humanTotalTimeSpent = "human_total_time_spent"
  }
}
