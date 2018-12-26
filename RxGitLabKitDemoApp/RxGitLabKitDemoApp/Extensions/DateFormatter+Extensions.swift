//
//  DateFormatter+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 25/12/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation

extension DateFormatter {
  
  /// A full ISO8601 Date format
  static var iso8601full: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return dateFormatter
  }
  
  /// A ISO8601 Date format
  static var iso8601: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }
  
  /// A "yyyy-MM-dd" Date format
  static var yyyyMMdd: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
}
