//
//  LoginViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: BaseViewController {
    
  var viewModel: LoginViewModel!
  
  let hostLabel: UILabel = {
    let label = UILabel()
    label.text = "Host"
    return label
  }()
  
  let hostTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  } ()
  
  let userNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username or e-mail"
    return label
  } ()
  
  let userNameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.text = "dagytran@gmail.com"
    return textField
  } ()
  
  let passwordLabel: UILabel = {
    let label = UILabel()
    label.text = "Password"
    return label
  } ()
  
  let passwordTextField: UITextField = {
    let textField = UITextField()
    textField.isSecureTextEntry = true
    textField.borderStyle = .roundedRect
    return textField
  } ()
  
  let privateTokenLabel: UILabel = {
    let label = UILabel()
    label.text = "Private Token"
    return label
  } ()
  
  let privateTokenField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  } ()
  
  let oAuthTokenLabel: UILabel = {
    let label = UILabel()
    label.text = "OAuth Token"
    return label
  } ()
  
  let oAuthTokenTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  } ()
  
  let authorizeButton: UIButton = {
    let button = UIButton()
    button.setTitle("Authorize", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    return button
  } ()
  
  private let loginTrigger = PublishSubject<[String : String]>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.hidesBackButton = true

    title = "Login"
    view.backgroundColor = .white
    hostTextField.text = viewModel.gitlabClient.hostURL.absoluteString
    
    let stackView = UIStackView(arrangedSubviews: [hostLabel, hostTextField, userNameLabel, userNameTextField, passwordLabel, passwordTextField, privateTokenLabel, privateTokenField, oAuthTokenLabel, oAuthTokenTextField])
    stackView.axis = .vertical
    stackView.spacing = 10
    view.addSubview(stackView)
    stackView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.lessThanOrEqualToSuperview().inset(30)
      make.width.greaterThanOrEqualTo(350)
      make.height.equalTo(340)
    }
    view.addSubview(authorizeButton)
    authorizeButton.snp.makeConstraints { (make) in
      make.top.equalTo(stackView.snp.bottom).offset(32)
      make.centerX.equalToSuperview()
    }
    
    setupBinding()
  }
  
  private func setupBinding() {
    authorizeButton.rx.tap.bind {
      var fields = [String: String]()
      if let hostURLString = self.hostTextField.text, !hostURLString.isEmpty {
        fields["hostURL"] = hostURLString
      }
      
      if let username = self.userNameTextField.text, let password = self.passwordTextField.text, !username.isEmpty, !password.isEmpty  {
        fields["username"] = username
        fields["password"] = password
      }
      
      if let privateToken = self.privateTokenField.text, !privateToken.isEmpty  {
        fields["privateToken"] = privateToken
      }
      
      if let oAuthToken = self.oAuthTokenTextField.text, !oAuthToken.isEmpty  {
        fields["oAuthToken"] = oAuthToken
      }
      
      self.viewModel.login(fields: fields)
      }
      .disposed(by: disposeBag)
    
    viewModel.user
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (user) in
        self.showProfileVC()
      })
      .disposed(by: disposeBag)
    
  }
  
  private func showLoginFailedAlert(_ message: String) {
    let alert = UIAlertController(title: "Log In Failed", message: message, preferredStyle: .alert)
    alert.title = "Log In Failed"
    alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  private func showProfileVC() {
    let profileVC = ProfileViewController()
    profileVC.viewModel = ProfileViewModel(with: self.viewModel.gitlabClient)
    self.navigationController?.popViewController(animated: true)
  }
  
}
