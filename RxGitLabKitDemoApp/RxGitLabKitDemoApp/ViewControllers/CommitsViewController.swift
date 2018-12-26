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

/// Shows a list of commits for a given project
class CommitsViewController: BaseViewController {
  
  // MARK: UI components
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CommitTableViewCell.self, forCellReuseIdentifier: CommitTableViewCell.cellIdentifier)
    return tableView
  } ()
  
  private let loadingIndicator = UIActivityIndicatorView(style: .gray)
  
  // MARK: View Model
  var viewModel: CommitsViewModel!
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Commits"
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.loadNextProjectPage()
  }
  
  override func addUIComponents() {
    view.addSubview(tableView)
    tableView.tableFooterView = loadingIndicator
  }
  
  override func layoutUIComponents() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func setupBindings() {
    
    // Table data
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: CommitTableViewCell.cellIdentifier, cellType: CommitTableViewCell.self)) { _, element, cell in
        cell.commit = element
      }
      .disposed(by:disposeBag)
    
    // Show empty table message if the projects
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
    
    // Shows commit detail when tapped on item
    tableView.rx.itemSelected
      .subscribe(onNext: { indexPath in
        self.showDetail(indexPath)
      })
      .disposed(by: disposeBag)
    
    // Loads more objects when the table reaches the end
    tableView.rx.willBeginDecelerating
      .subscribe(onNext: { _ in
        if self.tableView.isReachingEnd {
          self.viewModel.loadNextProjectPage()
        }
      })
      .disposed(by: disposeBag)
    
    // Loading indicator
    viewModel.isLoading
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (isLoading) in
        if isLoading {
          self.loadingIndicator.startAnimating()
        } else {
          self.loadingIndicator.stopAnimating()
        }
      })
      .disposed(by:disposeBag)
  }
  
  /// Shows commit detail
  private func showDetail(_ indexPath: IndexPath) {
    let commitDetailVC = CommitDetailViewController()
    commitDetailVC.viewModel = CommitDetailViewModel(with: self.viewModel.gitlabClient, commit: self.viewModel.commit(for: indexPath.row), projectID: self.viewModel.projectID)
    self.showDetailViewController(UINavigationController(rootViewController: commitDetailVC), sender: self)
  }
}
