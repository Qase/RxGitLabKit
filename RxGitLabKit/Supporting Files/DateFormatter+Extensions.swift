//
//  DateFormatter+Extensions.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 07/10/2018.
//

import Foundation

extension DateFormatter {
  public static var `default`: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return dateFormatter
  }
}
