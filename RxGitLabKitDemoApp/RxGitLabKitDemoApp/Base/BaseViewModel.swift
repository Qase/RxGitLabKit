//
//  BaseViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift

/// A base view model with common attributes
class BaseViewModel {
  
  /// A dispose bag for disposing subscriptions
  internal let disposeBag = DisposeBag()
}
