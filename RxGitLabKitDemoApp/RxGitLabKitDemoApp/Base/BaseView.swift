//
//  BaseView.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift

/// A base view with common attributes
class BaseView: UIView {
  
  /// A dispose bag for disposing subscriptions
  let disposeBag = DisposeBag()
}
