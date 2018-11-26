//
//  Date+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 20/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation

extension Date {
  static func from(string: String, using formatter: DateFormatter = DateFormatter.default) -> Date? {
    return formatter.date(from: string)
  }
  
  var asISO8601String: String {
    let formatter = ISO8601DateFormatter()
    return formatter.string(from: self)
  }
  
  var localizedString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
  
}
