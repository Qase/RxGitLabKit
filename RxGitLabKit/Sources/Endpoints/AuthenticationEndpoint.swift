//
//  AuthenticationEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation
import RxSwift

public class AuthenticationEndpoint: Endpoint {
  
  public enum Endpoints {
    case token
    
    var path: String {
      switch self {
      case .token:
        return "/oauth/token"
      }
    }
  }
  
  public func authenticate(username: String, password: String) -> Observable<Authentication> {
    let jsonBody = [
      "grant_type" : "password",
      "username" : username,
      "password" : password
    ]
    let apiRequest = APIRequest(path: Endpoints.token.path, method: .post, jsonBody: jsonBody)
    
    guard let request = apiRequest.buildRequest(with: self.hostURL, apiVersion: nil) else { return Observable.error(NetworkingError.invalidRequest(message: nil)) }
    
    return network.object(for: request)
  }
  
}
