//
//  UITableView+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 24/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

extension UITableView {
  
  func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = .black
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = .center;
    messageLabel.sizeToFit()
    
    self.backgroundView = messageLabel;
    self.separatorStyle = .none;
  }
  
  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
  
  var isReachingEnd: Bool {
    return contentOffset.y >= 0 && contentOffset.y > (contentSize.height - frame.size.height)
  }
}
