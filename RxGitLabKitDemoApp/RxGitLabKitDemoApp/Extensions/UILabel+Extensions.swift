//
//  UILabel+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 26/12/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

extension UILabel {
  
  /// Initializes an `UILabel` 
  convenience init(with text: String) {
    self.init()
    self.text = text
  }
}
