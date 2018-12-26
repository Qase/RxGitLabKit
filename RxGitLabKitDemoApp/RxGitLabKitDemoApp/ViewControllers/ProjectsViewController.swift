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

class ProjectsViewController: BaseViewController, UISplitViewControllerDelegate {
  
  private let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.scopeButtonTitles = ["All Projects", "User Projects"]
    searchBar.showsScopeBar = true
    searchBar.placeholder = "Search for projects ..."
    searchBar.sizeToFit()
    searchBar.scopeBarBackgroundImage = UIImage()
    searchBar.returnKeyType = .done
    return searchBar
  } ()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.cellIdentifier)
    return tableView
  }()
  
  private let loadingIndicator = UIActivityIndicatorView(style: .gray)

  var viewModel: ProjectsViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Projects"
    setupSearchBar()
    setupTableView()
    setupTableViewBinding()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    viewModel.loadProjects()
  }
  
  private func setupNavbar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupSearchBar() {
    navigationItem.titleView = searchBar
    searchBar.rx
      .selectedScopeButtonIndex
      .map { $0 == 1 }
      .bind(to: viewModel.isUserTabSelectedVariable)
      .disposed(by: disposeBag)
    searchBar.rx.searchButtonClicked.subscribe({ _ in
      self.searchBar.endEditing(true)
    })
      .disposed(by: disposeBag)

    searchBar.rx.text
      .throttle(0.2, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: viewModel.searchTextVariable)
      .disposed(by: disposeBag)
  }
  
  private func setupTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    tableView.tableFooterView = loadingIndicator
  }
  
  private func setupTableViewBinding() {
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
    viewModel.isLoadingPublisher.asObservable()
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
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return true
  }
  
}
