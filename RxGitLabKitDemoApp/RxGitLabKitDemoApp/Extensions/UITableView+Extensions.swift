//
//  UITableView+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 24/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

extension UITableView {
  
  /// Sets a message in the background
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0
    messageLabel.sizeToFit()
    messageLabel.textAlignment = .center
    self.backgroundView = messageLabel;
    self.separatorStyle = .none;
  }
  
  /// Removes the message from the background
  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
  
  /// Returns `true` if the scroll is reaching end,
  /// returns `false` otherwise
  var isReachingEnd: Bool {
    return contentOffset.y >= 0 && contentOffset.y > (contentSize.height - frame.size.height)
  }
}
