//
//  BaseViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift

/// A base view controller with common attributes
class BaseViewController: UIViewController {
  
  /// A dispose bag for disposing subscriptions
  internal let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addUIComponents()
    layoutUIComponents()
    setupBindings()
  }
  
  /// Adds the UI components to `view`.
  /// This function is called in `viewDidLoad()`.
  internal func addUIComponents() {}
  
  /// Applies constraints on UI Components.
  /// This function is called in `viewDidLoad()`.

  internal func layoutUIComponents() {}
  
  /// Sets up component bindings.
  /// This function is called in `viewDidLoad()`.
  internal func setupBindings() {}
}
