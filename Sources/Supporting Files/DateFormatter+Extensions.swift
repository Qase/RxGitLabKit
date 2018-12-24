//
//  DateFormatter+Extensions.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 07/10/2018.
//

import Foundation

extension DateFormatter {
  
  /// A full ISO8601 Date format
  public static var iso8601full: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter
  }
  
  /// A ISO8601 Date format
  public static var iso8601: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }
  
  /// A "yyyy-MM-dd" Date format
  public static var yyyyMMdd: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
}
