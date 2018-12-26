//
//  AuthenticationEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation
import RxSwift

/**
 This EndpointGroup authentication using an `username` and a `password`
 The user can authenticate using `username` and `password` which will return an OAuth Token. If OAuth Token or Private Token is already known, it can be used when initiating RxGitLabAPI.
 */
public class AuthenticationEndpointGroup: EndpointGroup {
  
  internal enum Endpoints {
    case token
    
    public var url: String {
      switch self {
      case .token:
        return "/oauth/token"
      }
    }
  }
  
  
  /**
   Authenticate using `username` and `password`
   
   Get an Authentication object using `username` and `password`
   - Parameters:
   - username: username
   - password: password
   - Returns: An `Observable` of `Authentication` 
   */
  public func authenticate(username: String, password: String) -> Observable<Authentication> {
    let jsonBody = [
      "grant_type" : "password",
      "username" : username,
      "password" : password
    ]
    let apiRequest = APIRequest(path: Endpoints.token.url, method: .post, jsonBody: jsonBody, apiVersion: nil)
    return object(for: apiRequest)
  }
  
}
