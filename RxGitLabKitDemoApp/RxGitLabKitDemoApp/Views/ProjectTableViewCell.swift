//
//  ProjectTableViewCell.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift
import RxGitLabKit

class ProjectTableViewCell: BaseTableViewCell {
  
  var project: Project! {
    didSet {
      textLabel?.text = "\(project.namespace.name)/\(project.name)"
      detailTextLabel?.text = "Star count: \(project.starCount)\tForks count: \(project.forksCount)"
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: ProjectTableViewCell.cellIdentifier)
    textLabel?.textColor = UIColor.blue
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
