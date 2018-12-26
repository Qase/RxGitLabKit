//
//  AppDelegate.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import RxSwift
import RxBlocking
import RxGitLabKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

  var window: UIWindow?
  private let disposeBag = DisposeBag()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let gitlabClient = RxGitLabAPIClient(with: URL(string: "https://gitlab.com")!)
    
    // Setting up Projects tab in split view
    let masterVC = ProjectsViewController()
    masterVC.viewModel = ProjectsViewModel(with: gitlabClient)
    let detailVC = CommitDetailViewController()
    let splitVC = BaseSplitViewController()
    splitVC.viewControllers = [UINavigationController(rootViewController: masterVC), UINavigationController(rootViewController:detailVC)]
    let folderImage = UIImage(named: "fa-folder")!
    folderImage.withRenderingMode(.alwaysTemplate)
    splitVC.tabBarItem = UITabBarItem(title: "Projects", image: folderImage, selectedImage: folderImage)

    // Setting up profile tab
    let loginVC = LoginViewController()
    loginVC.viewModel = LoginViewModel(using: gitlabClient)
    let settingsNavigationController = UINavigationController(rootViewController: loginVC)
    let userImage = UIImage(named: "fa-user")!
    userImage.withRenderingMode(.alwaysTemplate)
    settingsNavigationController.tabBarItem = UITabBarItem(title: "User", image: userImage, selectedImage: userImage)

    // Tab Controller
    let tabController = UITabBarController()
    tabController.setViewControllers([splitVC, settingsNavigationController], animated: true)
    
    // Showing the screens
    self.window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()
    return true
  }
}

