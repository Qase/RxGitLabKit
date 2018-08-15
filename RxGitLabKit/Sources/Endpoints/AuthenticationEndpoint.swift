//
//  AuthenticationEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation
import RxSwift

class AuthenticationEndpoint: Endpoint {
  
  enum Endpoints {
    case token
    
    var path: String {
      switch self {
      case .token:
        return "/oauth/token"
      }
    }
  }
  
  private func path() -> String {
    return "/oauth/token"
  }
  
  func authenticate(username: String, password: String) -> Observable<Authentication> {
    let jsonBody = [
      "grant_type" : "password",
      "username" : username,
      "password" : password
    ]
    let request = APIRequest(path: Endpoints.token.path, method: .post, jsonBody: jsonBody)
    
    return object(for: request)
  }
  
}
