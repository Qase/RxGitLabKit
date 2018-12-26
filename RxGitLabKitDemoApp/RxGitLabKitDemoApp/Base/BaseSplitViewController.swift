//
//  BaseSplitViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit

/// A base split view controller with common attributes
class BaseSplitViewController: UISplitViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    preferredDisplayMode = .allVisible
    delegate = self
  }
}

extension BaseSplitViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController,
                           collapseSecondary secondaryViewController: UIViewController,
                           onto primaryViewController: UIViewController) -> Bool {
    return true
  }
}
