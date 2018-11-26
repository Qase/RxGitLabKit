//
//  SettingsViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/11/2018.
//  Copyright © 2018 Dagy Tran. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
  
  var viewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
      let button = UIButton(type: .roundedRect)
      button.setTitle("Title", for: .normal)
      button.rx.tap.bind {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.yellow
        vc.title = "Pushed VC"
        self.navigationController?.pushViewController(vc, animated: true)
      }
      view.addSubview(button)
      button.snp.makeConstraints { (make) in
        make.center.equalToSuperview()
      }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
