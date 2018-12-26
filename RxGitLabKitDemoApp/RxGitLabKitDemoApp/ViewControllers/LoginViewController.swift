//
//  LoginViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 18/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift
import RxGitLabKit

class LoginViewController: BaseViewController {
  
  // MARK: UI Components
  private let hostTextField: UITextField = UITextField.withRoundedCorners
  
  private let userNameTextField: UITextField = {
    let textField = UITextField.withRoundedCorners
    textField.textContentType = .username
    return textField
  }()
  
  private let passwordTextField: UITextField = {
    let textField = UITextField.withRoundedCorners
    textField.isSecureTextEntry = true
    textField.textContentType = .password
    return textField
  }()
  
  private let privateTokenField: UITextField = UITextField.withRoundedCorners
  
  private let oAuthTokenTextField: UITextField = UITextField.withRoundedCorners
  
  private let authorizeButton: UIButton = {
    let authorizeButton = UIButton()
    authorizeButton.setTitle("Authorize", for: .normal)
    authorizeButton.setTitleColor(.blue, for: .normal)
    authorizeButton.setTitleColor(.gray, for: .disabled)
    return authorizeButton
  } ()
  
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    return indicator
  } ()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView(frame: .zero)
    stackView.axis = .vertical
    stackView.spacing = 10
    return stackView
  } ()
  
  private let tapRecognizer = UITapGestureRecognizer()
  
  // MARK: View Model
  
  var viewModel: LoginViewModel!
  
  private let loginTrigger = PublishSubject<[String : String]>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.hidesBackButton = true
    title = "Login"
    view.backgroundColor = .white
  }
  
  override func addUIComponents() {
    let hostLabel = UILabel(with: "Host")
    let userNameLabel = UILabel(with: "Username or e-mail")
    let passwordLabel = UILabel(with: "Password")
    let privateTokenLabel = UILabel(with: "Private Token")
    let oAuthTokenLabel = UILabel(with: "OAuth Token")
    
    //    hostTextField.text = viewModel.gitlabClient.hostURL.absoluteString
    hostTextField.text = "gitlab.fel.cvut.cz"
    userNameTextField.text = "dagytran@gmail.com"
    passwordTextField.text = "Wood_Thor9_3shill"
    oAuthTokenTextField.text = "5e8672700e931c97830b4c0679e065de35c8b63c913df262a18b915e31138218"
    privateTokenField.text = "ev1TKZXRDF9dkxwnZS4a"
    
    stackView.addArrangedSubview(hostLabel)
    stackView.addArrangedSubview(hostTextField)
    stackView.addArrangedSubview(userNameLabel)
    stackView.addArrangedSubview(userNameTextField)
    stackView.addArrangedSubview(passwordLabel)
    stackView.addArrangedSubview(passwordTextField)
    stackView.addArrangedSubview(privateTokenLabel)
    stackView.addArrangedSubview(privateTokenField)
    stackView.addArrangedSubview(oAuthTokenLabel)
    stackView.addArrangedSubview(oAuthTokenTextField)
    view.addSubview(stackView)
    view.addSubview(authorizeButton)
    view.addGestureRecognizer(tapRecognizer)
    view.addSubview(loadingIndicator)
  }
  
  override func layoutUIComponents() {
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(32)
      make.centerX.equalToSuperview()
      make.width.lessThanOrEqualToSuperview().inset(30)
      make.width.greaterThanOrEqualTo(350)
      make.height.equalTo(340)
    }
    authorizeButton.snp.makeConstraints { (make) in
      make.top.equalTo(stackView.snp.bottom).offset(32)
      make.centerX.equalToSuperview()
    }
    loadingIndicator.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  override func setupBindings() {
    // Login
    authorizeButton.rx.tap
      .do(onNext: {
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
        self.authorizeButton.isEnabled = false
        self.loadingIndicator.startAnimating()
        self.viewModel.login(fields: fields)
      })
      .flatMap { _ in
        return self.viewModel.user.take(1)
      }
      .debug()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (user) in
        self.loadingIndicator.stopAnimating()
        self.authorizeButton.isEnabled = true
        if let user = user {
          self.showProfileVC(with: user)
        } else {
          self.showLoginFailedAlert("Login failed")
        }
      })
      .disposed(by: disposeBag)
    
    // Hiding the keyboard when tapped else where
    tapRecognizer.rx.event.subscribe(onNext: { (gesture) in
      self.view.endEditing(true)
    })
      .disposed(by: disposeBag)
    
    // Button disabling if the input is empty
    let hostObservable = hostTextField.rx.text.map { $0 == nil || $0!.isEmpty}
    let usernameObservable = userNameTextField.rx.text.map { $0 == nil || $0!.isEmpty}
    let passwordObservable = passwordTextField.rx.text.map { $0 == nil || $0!.isEmpty}
    
    let oAuthTokenObservable = oAuthTokenTextField.rx.text.map { $0 == nil || $0!.isEmpty}
    let privateTokenObservable = privateTokenField.rx.text.map { $0 == nil || $0!.isEmpty}
    
    // Login button enable/disable based on inputs
    Observable.combineLatest(hostObservable, usernameObservable, passwordObservable, oAuthTokenObservable, privateTokenObservable, resultSelector: { isHostEmpty, isUsernameEmpty, isPasswordEmpty, isOAuthTokenEmpty, isPrivateTokenEmpty  in
      return !isHostEmpty && (
        (!isUsernameEmpty && !isPasswordEmpty)
          || !isOAuthTokenEmpty
          || !isPrivateTokenEmpty
      )
    })
      .bind(to: authorizeButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
  }
  
  /// Shows allert if login fails
  private func showLoginFailedAlert(_ message: String) {
    let alert = UIAlertController(title: "Log In Failed", message: message, preferredStyle: .alert)
    alert.title = "Log In Failed"
    alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  /// Shows user profile
  private func showProfileVC(with user: User) {
    let profileVC = ProfileViewController()
    profileVC.viewModel = ProfileViewModel(with: self.viewModel.gitlabClient, user: user)
    self.navigationController?.pushViewController(profileVC, animated: true)
  }
  
}
