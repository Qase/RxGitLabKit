//
//  ProjectsModel.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 25/12/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxGitLabKit

class ProjectsModel {
  let projects = Variable<[Project]>([])
  let userProjects = Variable<[Project]>([])
}
