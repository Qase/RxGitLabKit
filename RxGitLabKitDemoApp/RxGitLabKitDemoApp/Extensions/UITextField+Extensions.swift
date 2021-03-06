//
//  UITextField+Extensions.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 26/12/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

extension UITextField {
  
  /// Creates an `UITextField` with rounded corners
  ///
  /// `textField.borderStyle = .roundedRect`
  static var withRoundedCorners: UITextField {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  }
}
