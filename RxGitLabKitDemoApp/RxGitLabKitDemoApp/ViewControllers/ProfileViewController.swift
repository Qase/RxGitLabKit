//
//  ProfileViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGitLabKit

/// Shows information about the logged in user
class ProfileViewController: BaseViewController {
  
  /// Shows basic information about the user
  class ProfileTableHeaderView: BaseView {
    
    private let avatarImageView: UIImageView = {
      let avatarImageView = UIImageView()
      avatarImageView.clipsToBounds = true
      avatarImageView.layer.cornerRadius = 8
      avatarImageView.layer.masksToBounds = true
      avatarImageView.layer.borderColor = UIColor.black.cgColor
      return avatarImageView
    } ()
    
    init(name: String, email: String, avatarURL: URL?, bio: String? = nil) {
      super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 152))
      
      let containerView = UIView()
      addSubview(containerView)
      containerView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.width.greaterThanOrEqualTo(200)
        make.top.bottom.equalToSuperview().inset(16)
      }
      
      containerView.addSubview(avatarImageView)
      
      if let avatarURL = avatarURL {
        loadImage(avatarURL)
      }
      avatarImageView.snp.makeConstraints { (make) in
        make.left.equalToSuperview()
        make.height.equalToSuperview()
        make.width.equalTo(avatarImageView.snp.height)
      }
      
      let nameLabel = UILabel()
      nameLabel.text = name
      containerView.addSubview(nameLabel)
      nameLabel.snp.makeConstraints { (make) in
        make.right.top.equalToSuperview().inset(16)
        make.height.equalTo(20)
        make.left.equalTo(avatarImageView.snp.right).offset(16)
      }
      
      let emailLabel = UILabel()
      emailLabel.textColor = .gray
      emailLabel.text = email
      containerView.addSubview(emailLabel)
      emailLabel.snp.makeConstraints { (make) in
        make.right.equalToSuperview().inset(16)
        make.top.equalTo(nameLabel.snp.bottom).offset(16)
        make.height.equalTo(20)
        make.left.equalTo(avatarImageView.snp.right).offset(16)
      }
      
      let bioLabel = UILabel()
      bioLabel.text = bio
      bioLabel.textColor = .lightGray
      containerView.addSubview(bioLabel)
      bioLabel.snp.makeConstraints { (make) in
        make.right.bottom.equalToSuperview().inset(16)
        make.top.equalTo(emailLabel.snp.bottom)
        make.left.equalTo(avatarImageView.snp.right).offset(16)
      }
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(_ imageURL: URL) {
      URLSession.shared.rx
        .response(request: URLRequest(url: imageURL))
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (response, data) in
          self?.avatarImageView.image = UIImage(data: data)
        })
        .disposed(by: disposeBag)
    }
  }
  
  // MARK: UI Components
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.allowsSelection = false
    tableView.insetsContentViewsToSafeArea = true
    tableView.insetsLayoutMarginsFromSafeArea = true
    tableView.contentInsetAdjustmentBehavior = .automatic
    tableView.register(CommitDetailTableViewCell.self, forCellReuseIdentifier: CommitDetailTableViewCell.cellIdentifier)
    return tableView
  } ()
  
  private let logoutButton: UIButton = {
    let button = UIButton()
    button.setTitle("Log Out", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.backgroundColor = UIColor.red
    button.layer.cornerRadius = 8
    button.clipsToBounds = true
    button.layer.masksToBounds = true
    return button
  } ()
  
  private let logoutView = UIView(frame: .init(x: 0, y: 0, width: 300, height: 150))
  
  // MARK: View Model
  var viewModel: ProfileViewModel!
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Profile"
    navigationItem.hidesBackButton = true
  }
  
  override func addUIComponents() {
    view.addSubview(tableView)
    
    let user = viewModel.user
    self.tableView.tableHeaderView = ProfileTableHeaderView(name: user.name ?? "", email: user.email ?? "", avatarURL: user.avatarUrl != nil ? URL(string: user.avatarUrl!) : nil, bio: user.bio ?? "")
    logoutView.addSubview(logoutButton)
    tableView.tableFooterView = logoutView
  }
  
  override func layoutUIComponents() {
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    logoutButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(200)
      make.height.equalTo(50)
    }
  }
  
  override func setupBindings() {
    // TableView bindings
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: CommitDetailTableViewCell.cellIdentifier, cellType: CommitDetailTableViewCell.self)) { row, element, cell in
        cell.textLabel?.text = element.0
        cell.detailTextLabel?.text = element.1
      }
      .disposed(by: disposeBag)
    
    // Logout button
    logoutButton.rx
      .tap
      .subscribe { _ in self.logOut() }
      .disposed(by: disposeBag)
  }
  
  // MARK: Private functions
  
  // Loggs out the user and pops the view
  private func logOut() {
    viewModel.logOut()
    self.navigationController?.popViewController(animated: true)
  }
}
