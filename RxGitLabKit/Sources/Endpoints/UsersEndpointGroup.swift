//
//  UsersEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class UsersEndpointGroup: EndpointGroup {
  
  enum Endpoints {
    case currentUser
    case status
    case user(userID: String)
    case users
    case usersStatus(userID: String)

    case sshKey(keyID: String)
    case sshKeys
    case usersSSHKey(userID: String, keyID: String)
    case usersSSHKeys(userID: String)
    
    case gpgKey(keyID: String)
    case gpgKeys
    case usersGPGKey(userID: String, keyID: String)
    case usersGPGKeys(userID: String)
    
    case email(emailID: String)
    case emails
    case usersEmail(userID: String, emailID: String)
    case usersEmails(userID: String)
    
    case blockUser(userID: String)
    case unBlockUser(userID: String)
    
    case usersImpersonationToken(userID: String, impersonationTokenID: String)
    case usersImpersonationTokens(userID: String)
    
    case activities
    
    var url: String {
      switch self {
      case .currentUser:
        return "/user"
      case .status:
        return "/user/status"
      case .user(let userID):
        return "/users/\(userID)"
      case .users:
        return "/users"
      case .usersStatus(let userID):
        return "/users/\(userID)/status"
      case .sshKey(let keyID):
        return "/users/keys/\(keyID)"
      case .sshKeys:
        return "/user/keys"
      case .usersSSHKey(let userID, let keyID):
        return "/users/\(userID)/\(keyID)"
      case .usersSSHKeys(let userID):
        return "/users/\(userID)/keys"
      case .gpgKey(let keyID):
        return "/user/gpg_keys/\(keyID)"
      case .gpgKeys:
        return "/user/gpg_keys"
      case .usersGPGKey(let userID, let keyID):
        return "/users/\(userID)/gpg_keys/\(keyID)"
      case .usersGPGKeys(let userID):
        return "/users/\(userID)/gpg_keys"
      case .email(let emailID):
        return "/user/emails/\(emailID)"
      case .emails:
        return "/user/emails"
      case .usersEmail(let userID, let emailID):
        return "/users/\(userID)/emails/\(emailID)"
      case .usersEmails(let userID):
        return "/users/\(userID)/emails"
      case .blockUser(let userID):
        return "/users/\(userID)/block"
      case .unBlockUser(let userID):
        return "/users/\(userID)/unblock"
      case .usersImpersonationToken(let userID, let impersonationTokenID):
        return "/users/\(userID)/impersonation_tokens/\(impersonationTokenID)"
      case .usersImpersonationTokens(let userID):
        return "/users/\(userID)/impersonation_tokens"
      case .activities:
        return "/users/activities"
      }
    }
  }
  
  public func getUsers(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Paginator<User> {
    let apiRequest = APIRequest(path: Endpoints.users.url, method: .get)
    let paginator = Paginator<User>(network: network, hostURL: hostURL, apiRequest: apiRequest)
    paginator.page = page
    paginator.perPage = perPage
    oAuthToken.asObservable()
      .filter({$0 != nil})
      .bind(to: paginator.oAuthToken)
      .disposed(by: paginator.disposeBag)
    privateToken.asObservable()
      .filter({$0 != nil})
      .bind(to: paginator.privateToken)
      .disposed(by: paginator.disposeBag)
    
    return paginator
  }
  
}
