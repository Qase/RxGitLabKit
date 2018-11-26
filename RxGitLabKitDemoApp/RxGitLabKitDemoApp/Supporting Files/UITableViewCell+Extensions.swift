//
//  UITableViewCell+extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

extension UITableViewCell {
  static var cellIdentifier: String {
    return String(describing: self)
  }
}
