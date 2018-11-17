//
//  AuthenticationEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation
import RxSwift

public class AuthenticationEndpointGroup: EndpointGroup {

  public enum Endpoints {
    case token

    public var url: String {
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
    let apiRequest = APIRequest(path: Endpoints.token.url, method: .post, jsonBody: jsonBody)
    return hostCommunicator.object(for: apiRequest, apiVersion: nil)
  }

}
