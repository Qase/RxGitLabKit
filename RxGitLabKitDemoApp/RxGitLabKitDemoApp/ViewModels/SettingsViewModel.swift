//
//  SettingsViewModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation

class ProfileViewModel {
  let gitlabService: GitLabService!

  init(with gitlabService: GitLabService) {
    self.gitlabService = gitlabService
  }
}
