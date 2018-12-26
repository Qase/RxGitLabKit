//
//  CommitDetailViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift
import RxGitLabKit
import SnapKit

class CommitDetailViewController: BaseViewController {
  
  // MARK: UI Components
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommitDetailTableViewCell.self, forCellReuseIdentifier: CommitDetailTableViewCell.cellIdentifier)
    tableView.tableFooterView = UIView()
    tableView.allowsSelection = false
    tableView.setEmptyMessage("Please select a commit from a project.")
    return tableView
  } ()
  
  let refreshControl = UIRefreshControl()
  
  // MARK: View Model
  /// View Model can be nil
  var viewModel: CommitDetailViewModel!
  
  override func viewDidLoad() {
    if viewModel != nil {
      super.viewDidLoad()
    }
    title = "Commit Detail"
    view.backgroundColor = .white
  }
  
  override func addUIComponents() {
    view.addSubview(tableView)
    tableView.refreshControl = refreshControl
  }
  
  override func layoutUIComponents() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func setupBindings() {
    viewModel?.dataSource.bind(to: tableView.rx.items(cellIdentifier: CommitDetailTableViewCell.cellIdentifier, cellType: CommitDetailTableViewCell.self)) { index, element, cell in
      let labels = element
      cell.textLabel?.text = labels.0
      cell.detailTextLabel?.text = labels.1
      }
      .disposed(by: disposeBag)
    tableView.refreshControl?.beginRefreshing()
    
    self.viewModel?.dataSource
      .map { _ in return false}
      .bind(to:refreshControl.rx.isRefreshing)
      .disposed(by: disposeBag)
  }
  
}
