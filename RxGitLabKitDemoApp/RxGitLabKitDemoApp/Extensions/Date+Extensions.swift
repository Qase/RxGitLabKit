//
//  Date+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 20/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation

extension Date {
  
  /// A custom localized string
  public var localizedString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
  
  /// Returns a Date from String if successful
  ///
  /// - Parameters:
  ///   - string: Date
  ///   - formatter: A Date Formatter (default: ISO8601 Full)
  init?(from string: String, using formatter: DateFormatter = DateFormatter.iso8601full) {
    if let date =  formatter.date(from: string) {
      self = date
    }  else {
      return nil
    }
  }
  
  /// Returns a ISO8601 String representation
  var asISO8601String: String {
    return DateFormatter.iso8601.string(from: self)
  }
  
  /// Returns a String representation in "yyyy-MM-dd" format
  var asyyyyMMddString: String {
    let formatter = DateFormatter.yyyyMMdd
    return formatter.string(from: self)
  }

}
