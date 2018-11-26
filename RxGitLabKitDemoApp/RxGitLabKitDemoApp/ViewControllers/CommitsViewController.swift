//
//  CommitsViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxGitLabKit
import RxSwift

class CommitsViewController: BaseViewController {
  
  private weak var tableView: UITableView!
  private weak var emptyLabel: UILabel!
  
  var viewModel: CommitsViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Commits"
    navigationItem.largeTitleDisplayMode = .never
    setupTableView()
    setupTableViewBinding()
    if let isCollapsed = splitViewController?.isCollapsed, !isCollapsed{
      setupFirstCommitBinding()
    }
  }
  
  private func setupTableView() {
    let tableView = UITableView()
    view.addSubview(tableView)
    self.tableView = tableView
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.register(CommitTableViewCell.self, forCellReuseIdentifier: CommitTableViewCell.cellIdentifier)
    
    let emptyLabel = UILabel()
    emptyLabel.textAlignment = .center
    emptyLabel.numberOfLines = 4
    let emptyView = UIView()
    emptyView.addSubview(emptyLabel)
    emptyLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.right.equalToSuperview().inset(16)
    }
    self.emptyLabel = emptyLabel
    tableView.backgroundView = emptyView
    tableView.tableFooterView = UIView()
  }
  
  private func setupTableViewBinding() {
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: CommitTableViewCell.cellIdentifier, cellType: CommitTableViewCell.self)) { _, element, cell in
        cell.commit = element
      }
      .disposed(by:disposeBag)
    
    viewModel.dataSource
      .map { $0.isEmpty }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { isEmpty in
        if isEmpty {
          self.tableView.setEmptyMessage("There are no commits or the user is not authorized.")
        } else {
          self.tableView.restore()
        }
      })
      .disposed(by:disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { indexPath in
        self.showDetail(indexPath)
      })
      .disposed(by: disposeBag)
    
    tableView.rx.willBeginDecelerating
      .subscribe(onNext: { _ in
        if self.tableView.isReachingEnd {
          self.viewModel.loadNextProjectPage()
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func showDetail(_ indexPath: IndexPath) {
    let commitDetailVC = CommitDetailViewController()
    commitDetailVC.viewModel = CommitDetailViewModel(with: self.viewModel.gitlabClient, commit: self.viewModel.commit(for: indexPath.row), projectID: self.viewModel.projectID)
    
    self.showDetailViewController(UINavigationController(rootViewController: commitDetailVC), sender: self)
  }
  

  /// Shows Commit detail only if the app is in Split or Slideover mode - on iPads
  private func setupFirstCommitBinding() {
    viewModel.dataSource
      .observeOn(MainScheduler.instance)
      .subscribe { event in
        if let commits = event.element, commits.count > 0 {
          let indexPath = IndexPath(item: 0, section: 0)
          self.showDetail(indexPath)
          self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
      }
      .disposed(by: disposeBag)
  }
}
