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
  
  private weak var searchController: UISearchController!
  private weak var tableView: UITableView!
  private weak var refreshControl: UIRefreshControl!

  var viewModel: ProjectsViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Projects"
    modalPresentationStyle = .popover
    definesPresentationContext = true
    setupNavbar()
    setupSearchController()
    setupTableView()
    setupTableViewBinding()
  }
  
  private func setupNavbar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.scopeButtonTitles = ["All Projects", "User Projects"]
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    self.searchController = searchController
    
    searchController.searchBar.rx.selectedScopeButtonIndex
      .subscribe(onNext: { (index) in
        print(self.searchController.searchBar.scopeButtonTitles?[index] ?? "")
      })
      .disposed(by: disposeBag)
    
    searchController.searchBar.rx
      .selectedScopeButtonIndex
      .map { $0 == 1 }
      .bind(to: viewModel.isUserVariable)
      .disposed(by: disposeBag)
    
    searchController.searchBar.rx.text
      .throttle(0.2, scheduler: MainScheduler.instance)
      .bind(to: viewModel.searchTextVariable)
      .disposed(by: disposeBag)
  }
  
  private func setupBarButton() {
    let btn = UIBarButtonItem(title: "+", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = btn
    
    btn.rx.tap.subscribe({ _ in
      let vc = UIViewController()
      vc.view.backgroundColor = .red
      self.present(vc, animated: true, completion: nil)
    })
      .disposed(by: disposeBag)
  }
  
  private func setupTableView() {
    let tableView = UITableView()
    view.addSubview(tableView)
    tableView.tableFooterView = UIView()
    self.tableView = tableView
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: ProjectTableViewCell.cellIdentifier)
    
    let label = UILabel()
    label.text = "Please select a commit from a project."
    
    tableView.backgroundView = label
  }
  
  private func setupTableViewBinding() {
    tableView.rx.itemSelected
      .subscribe(onNext: { [unowned self] indexPath in
        let commitsVC = CommitsViewController()
        commitsVC.viewModel = CommitsViewModel(with: self.viewModel.gitlabClient, projectID: self.viewModel.projectID(for: indexPath.row).id)
        self.searchController.isActive = false
        self.navigationController?.pushViewController(commitsVC, animated: true)
      })
      .disposed(by: disposeBag)
    
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: ProjectTableViewCell.cellIdentifier, cellType: ProjectTableViewCell.self)) { row, element, cell in
        cell.project = element
      }
      .disposed(by: disposeBag)
    
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
    
    tableView.rx
      .willDisplayCell
      .subscribe(onNext: { cell, indexPath in
        if indexPath.row != self.viewModel.totalProjectsCount,
          indexPath.row == self.viewModel.projectsCount {
          self.viewModel.loadNextProjectPage()
        }
      })
      .disposed(by: disposeBag)
    
    tableView.rx
      .willBeginDecelerating
      .subscribe(onNext: { _ in
        if self.tableView.isReachingEnd {
          self.viewModel.loadNextProjectPage()
        }
      })
      .disposed(by: disposeBag)
  }
  
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return true
  }
  
}
