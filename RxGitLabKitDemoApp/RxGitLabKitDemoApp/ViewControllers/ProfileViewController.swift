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

class ProfileViewController: BaseViewController {
  
  class ProfileTableHeaderView: BaseView {
    
    private weak var avatarImageView: UIImageView!
    
    init(name: String, email: String, avatarURL: URL?, bio: String? = nil) {
      super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 152))
      
      let containerView = UIView()
      addSubview(containerView)
      containerView.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
        make.width.greaterThanOrEqualTo(200)
        make.top.bottom.equalToSuperview().inset(16)
      }
      
      let avatarImageView = UIImageView()
      containerView.addSubview(avatarImageView)
      avatarImageView.clipsToBounds = true
      avatarImageView.layer.cornerRadius = 8
      avatarImageView.layer.masksToBounds = true
      avatarImageView.layer.borderColor = UIColor.black.cgColor
      
      self.avatarImageView = avatarImageView
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
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (response, data) in
          DispatchQueue.main.async {
            self?.avatarImageView.image = UIImage(data: data)
          }
        })
        .disposed(by: disposeBag)
    }
  }
  
  private weak var tableView: UITableView!
  private weak var logoutButton: UIButton!
  
  var viewModel: ProfileViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    title = "Profile"
    navigationItem.hidesBackButton = true
    setupTableView()
    setupTableViewBinding()
    setupBindings()
    setupButton()
  }
 
  private func setupTableView() {
    let tableView = UITableView()
    view.addSubview(tableView)
    tableView.allowsSelection = false
    tableView.insetsContentViewsToSafeArea = true
    tableView.insetsLayoutMarginsFromSafeArea = true
    tableView.contentInsetAdjustmentBehavior = .automatic
    
    self.tableView = tableView
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    tableView.register(CommitDetailTableViewCell.self, forCellReuseIdentifier: CommitDetailTableViewCell.cellIdentifier)
  }
  
  private func setupTableViewBinding() {
    viewModel.dataSource
      .bind(to: tableView.rx.items(cellIdentifier: CommitDetailTableViewCell.cellIdentifier, cellType: CommitDetailTableViewCell.self)) { row, element, cell in
        cell.textLabel?.text = element.0
        cell.detailTextLabel?.text = element.1
      }
      .disposed(by: disposeBag)
  }
  
  private func setupBindings() {
      let userObservable = viewModel.gitlabClient.currentUserObservable
        .observeOn(MainScheduler.instance)
    
    userObservable.subscribe(onNext: { (user) in
      if user == nil {
        self.presentLoginModal()
      }
    })
      .disposed(by: disposeBag)
    
    userObservable.filter { $0 != nil}
      .subscribe(onNext: { (user) in
        guard let user = user else { return }
        self.tableView.tableHeaderView = ProfileTableHeaderView(name: user.name!, email: user.email!, avatarURL: user.avatarUrl != nil ? URL(string: user.avatarUrl!) : nil, bio: user.bio)
        self.tableView.reloadData()
      }, onError: { error in
        print(error.localizedDescription)
      })
      .disposed(by: disposeBag)
  }
  
  private func setupButton() {
    let logoutButton = UIButton()
    logoutButton.setTitle("Log Out", for: .normal)
    logoutButton.setTitleColor(UIColor.white, for: .normal)
    logoutButton.backgroundColor = UIColor.red
    logoutButton.layer.cornerRadius = 8
    logoutButton.clipsToBounds = true
    logoutButton.layer.masksToBounds = true
    let logoutView = UIView(frame: .init(x: 0, y: 0, width: 300, height: 150))
    logoutView.addSubview(logoutButton)
    logoutButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(200)
      make.height.equalTo(50)
    }
    self.logoutButton = logoutButton

    tableView.tableFooterView = logoutView
    logoutButton.rx
      .tap
      .subscribe(onNext: {
        self.logOut()
      })
      .disposed(by: disposeBag)
  }
  
  private func presentLoginModal() {
    let loginVM = LoginViewModel(using: viewModel.gitlabClient)
    let loginVC = LoginViewController()
    loginVC.viewModel = loginVM
    navigationController?.pushViewController(loginVC, animated: true)
  }
  
  private func logOut() {
    viewModel.logOut()
  }
}
