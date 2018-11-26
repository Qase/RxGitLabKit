//
//  CommitTableViewCell.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxGitLabKit
import RxSwift

class CommitTableViewCell: BaseTableViewCell {

  var commit: Commit! {
    didSet {
      textLabel?.text = commit.title
      detailTextLabel?.text = "\(commit.authorName) \t \(commit.shortId)\t \(commit.authoredDate?.localizedString ?? "")"
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
