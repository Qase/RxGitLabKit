//
//  Date+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 20/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation

extension Date {
  public var localizedString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
  
}
