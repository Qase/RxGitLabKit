//
//  GitLabAPIServicing.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation

enum Endpoints {
  
}

public protocol GitLabAPIServicing {
  
  
  func authenticate(server: URL)
  
  func authenticate(server: URL, privateToken: String)
  
  func authenticate(server: URL, OAuthToken: String)
  
  func authenticate(server: URL, email: String, password: String)

}


extension GitLabAPIServicing {
  
  
}
