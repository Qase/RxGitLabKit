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
    
    let masterVC = ProjectsViewController()
    masterVC.viewModel = ProjectsViewModel(with: gitlabClient)
    
    let detailVC = CommitDetailViewController()
    
    let splitVC = CustomSplitViewController()
    splitVC.viewControllers = [UINavigationController(rootViewController: masterVC), UINavigationController(rootViewController:detailVC)]

    let profileVM = ProfileViewModel(with: gitlabClient)
    let profileVC = ProfileViewController()
    profileVC.viewModel = profileVM
    
    let settingsNavigationController = UINavigationController(rootViewController: profileVC)

    let tabController = UITabBarController()
    tabController.setViewControllers([splitVC, settingsNavigationController], animated: true)
   
    let folderImage = UIImage(named: "fa-folder")!
    folderImage.withRenderingMode(.alwaysTemplate)
    
    splitVC.tabBarItem = UITabBarItem(title: "Projects", image: folderImage, selectedImage: folderImage)
    let userImage = UIImage(named: "fa-user")!
    userImage.withRenderingMode(.alwaysTemplate)
    settingsNavigationController.tabBarItem = UITabBarItem(title: "User", image: userImage, selectedImage: userImage)
    tabController.selectedIndex = 1
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()
    return true
  }
}

