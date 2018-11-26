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
  
  private weak var tableView: UITableView!
  
  var viewModel: CommitDetailViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Commit Detail"
    view.backgroundColor = .white
    if viewModel == nil {
      setupEmptyState()
    } else {
      setupTableView()
      setupTableViewBinding()
      setupRefresher()
    }
  }
  
  private func setupEmptyState() {
    let label = UILabel()
    label.text = "Please select a commit from a project."
    view.addSubview(label)
    label.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  private func setupTableView() {
    let tableView = UITableView()
    view.addSubview(tableView)
    self.tableView = tableView
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.register(CommitDetailTableViewCell.self, forCellReuseIdentifier: CommitDetailTableViewCell.cellIdentifier)
    tableView.tableFooterView = UIView()
    tableView.allowsSelection = false
  }
  
  private func setupTableViewBinding() {
    viewModel?.dataSource.bind(to: tableView.rx.items(cellIdentifier: CommitDetailTableViewCell.cellIdentifier, cellType: CommitDetailTableViewCell.self)) { index, element, cell in
      let labels = element
      cell.textLabel?.text = labels.0
      cell.detailTextLabel?.text = labels.1
    }
    .disposed(by: disposeBag)

  }
  
  private func setupRefresher() {
    let refreshControl = UIRefreshControl()
   tableView.refreshControl = refreshControl
  tableView.refreshControl?.beginRefreshing()
  self.viewModel?.dataSource
    .map { _ in return false}
    .bind(to:refreshControl.rx.isRefreshing)
    .disposed(by: disposeBag)
  }
}
