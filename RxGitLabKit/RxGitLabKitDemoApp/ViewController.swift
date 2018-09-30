//
//  ViewController.swift
//  RxGitLabKitDemoApp
//
//  Created by Dagy Tran on 17/08/2018.
//

import UIKit
import RxSwift
import RxGitLabKit

class ViewController: UIViewController {

  let bag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    let client = RxGitLabAPIClient(with: URL(string: "https://gitlab.com")!)
//    print(client)
//    client
//      .getOAuthToken(username: "dagytran@gmail.com", password: "S4b-F8a-2Kc-hnY")
//      .subscribe({ event in
//        print(event)
//        if let commits = event.element {
//          print(commits)
//        }
//      })
//    .disposed(by: bag)
    
    let client = RxGitLabAPIClient(with: URL(string: "https://gitlab.fel.cvut.cz/api/v4")!, privateToken: "ev1TKZXRDF9dkxwnZS4a")
    print(client)
    client
      .commits.get(projectID: "8093")
      .subscribe({ event in
        print(event)
        if let commits = event.element {
          print(commits)
        }
      })
      .disposed(by: bag)
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

