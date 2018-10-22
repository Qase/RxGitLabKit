//
//  Date+Extensions.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 21/10/2018.
//

import Foundation


extension Date {
  public static func from(string: String, using formatter: DateFormatter = DateFormatter.default) -> Date? {
    return formatter.date(from: string)
  }
}