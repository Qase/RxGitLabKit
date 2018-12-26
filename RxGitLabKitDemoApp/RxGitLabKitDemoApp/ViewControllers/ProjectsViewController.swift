//
//  ProjectsViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxGitLabKit
import RxSwift

/// This view controller shows a list of projects.
///
/// It can show all projects or user projects
/// Using search can help filter the desired projects
class ProjectsViewController: BaseViewController {
  
  // MARK: UI Components
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.scopeButtonTitles = ["All Projects", "User Projects"]
    searchBar.showsScopeBar = true
    searchBar.placeholder = "Search for projects ..."
    searchBar.sizeToFit()
    searchBar.scopeBarBackgroundImage = UIImage()
    searchBar.backgroundImage = UIImage()
    searchBar.returnKeyType = .done
    return searchBar
  } ()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.cellIdentifier)
    return tableView
  } ()
  
  private let loadingIndicator = UIActivityIndicatorView(style: .gray)
  
  // MARK: View Model
  var viewModel: ProjectsViewModel!
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Projects"
    view.backgroundColor = .white
  }
  
  // MARK: Setup
  
  // Adds the UI components to `view`
  override func addUIComponents() {
    view.addSubview(searchBar)
    view.addSubview(tableView)
    tableView.tableFooterView = loadingIndicator
  }
  
  // Applies constraints on UI Components
  override func layoutUIComponents() {
    searchBar.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.right.equalToSuperview()
    }
    
    tableView.snp.makeConstraints { make in
      make.left.bottom.right.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
  }
  
  override func setupBindings() {
    setupSearchBarBindings()
    setupTableViewBindings()
  }
  
  // MARK: Private functions
  private func setupSearchBarBindings() {
    // Scope button
    searchBar.rx
      .selectedScopeButtonIndex
      .map { $0 == 1 }
      .bind(to: viewModel.isUserTabSelectedVariable)
      .disposed(by: disposeBag)
    
    // Dismiss when done on keyboard is pressed
    searchBar.rx.searchButtonClicked
      .subscribe { _ in self.searchBar.endEditing(true) }
      .disposed(by: disposeBag)
    
    // Searchtext binding
    searchBar.rx.text
      .distinctUntilChanged()
      .bind(to: viewModel.searchTextVariable)
      .disposed(by: disposeBag)
  }
  
  private func setupTableViewBindings() {
    // Selecting item
    tableView.rx.itemSelected
      .subscribe(onNext: { [unowned self] indexPath in
        let commitsVC = CommitsViewController()
        commitsVC.viewModel = CommitsViewModel(with: self.viewModel.gitlabClient, projectID: self.viewModel.projectID(for: indexPath.row).id)
        self.navigationController?.pushViewController(commitsVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    // Cell data
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: ProjectTableViewCell.cellIdentifier, cellType: ProjectTableViewCell.self)) { row, element, cell in
        cell.project = element
      }
      .disposed(by: disposeBag)
    
    // Empty label
    viewModel.dataSource
      .map { $0.isEmpty }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { isEmpty in
        if isEmpty {
          self.tableView.setEmptyMessage("There are no projects or the user is not authorized.")
        } else {
          self.tableView.restore()
        }
      })
      .disposed(by:disposeBag)
    
    // Load more projects
    tableView.rx
      .willBeginDecelerating
      .subscribe(onNext: { _ in
        if self.tableView.isReachingEnd {
          if self.viewModel.isUserTabSelectedVariable.value {
            self.viewModel.loadNextUserProjectPage()
          } else {
            self.viewModel.loadNextProjectPage()
          }
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
}
