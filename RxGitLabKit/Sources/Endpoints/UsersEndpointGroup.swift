//
//  UsersEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class UsersEndpointGroup: EndpointGroup {

  public enum Endpoints {
    case currentUser
    case status
    case user(userID: Int)
    case users
    case usersStatus(userIDOrUsername: String)

    case sshKey(keyID: Int)
    case sshKeys
    case usersSSHKey(userID: Int, keyID: Int)
    case usersSSHKeys(userID: Int)

    case gpgKey(keyID: Int)
    case gpgKeys
    case usersGPGKey(userID: Int, keyID: Int)
    case usersGPGKeys(userID: Int)

    case email(emailID: Int)
    case emails
    case usersEmail(userID: Int, emailID: Int)
    case usersEmails(userID: Int)

    case blockUser(userID: Int)
    case unBlockUser(userID: Int)

    case usersImpersonationToken(userID: Int, impersonationTokenID: Int)
    case usersImpersonationTokens(userID: Int)

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

  public func getUsers(page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage, parameters: QueryParameters? = nil) -> Paginator<User> {
    let apiRequest = APIRequest(path: Endpoints.users.url, parameters: parameters)
    let paginator = Paginator<User>(network: network, hostURL: hostURL, apiRequest: apiRequest, page: page, perPage: perPage, oAuthToken: oAuthTokenVariable, privateToken: privateTokenVariable)

    return paginator
  }

  /// Get a single user.
  ///
  /// - Parameters:
  ///   - userID (required): The ID of the user
  ///   - parameters: Query Parameters [String: Any]
  /// - **Query Parameters:**
  ///   - email (required) - Email
  ///   - password (optional) - Password
  ///   - reset_password (optional) - Send user password reset link - true or false(default)
  ///   - username (required) - Username
  ///   - name (required) - Name
  ///   - skype (optional) - Skype ID
  ///   - linkedin (optional) - LinkedIn
  ///   - twitter (optional) - Twitter account
  ///   - website_url (optional) - Website URL
  ///   - organization (optional) - Organization name
  ///   - projects_limit (optional) - Number of projects user can create
  ///   - extern_uid (optional) - External UID
  ///   - provider (optional) - External provider name
  ///   - bio (optional) - User’s biography
  ///   - location (optional) - User’s location
  ///   - public_email (optional) - The public email of the user
  ///   - admin (optional) - User is admin - true or false (default)
  ///   - can_create_group (optional) - User can create groups - true or false
  ///   - skip_confirmation (optional) - Skip confirmation - true or false (default)
  ///   - external (optional) - Flags the user as external - true or false(default)
  ///   - avatar (optional) - Image file for user’s avatar
  ///   - private_profile (optional) - User’s profile is private - true or false
  /// - Returns: returns and observable of User?
  public func getUser(userID: Int, parameters: QueryParameters? = nil) -> Observable<User?> {
    let apiRequest = APIRequest(path: Endpoints.user(userID: userID).url, parameters: parameters)
    return object(for: apiRequest)
  }

  public func postUser(user: User) -> Observable<User> {
    do {
      let userData = try JSONEncoder().encode(user)
      let apiRequest = APIRequest(path: Endpoints.users.url, method: .post, data: userData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  /// Modifies an existing user. Only administrators can change attributes of a user.
  ///
  /// - Parameters:
  ///   - userID (required): The ID of the user
  ///   - parameters: Query Parameters [String: Any]
  /// - **Query Parameters:**
  ///   - email - Email
  ///   - username - Username
  ///   - name - Name
  ///   - password - Password
  ///   - skype - Skype ID
  ///   - linkedin - LinkedIn
  ///   - twitter - Twitter account
  ///   - website_url - Website URL
  ///   - organization - Organization name
  ///   - projects_limit - Limit projects each user can create
  ///   - extern_uid - External UID
  ///   - provider - External provider name
  ///   - bio - User’s biography
  ///   - location (optional) - User’s location
  ///   - public_email (optional) - The public email of the user
  ///   - admin (optional) - User is admin - true or false (default)
  ///   - can_create_group (optional) - User can create groups - true or false
  ///   - skip_reconfirmation (optional) - Skip reconfirmation - true or false (default)
  ///   - external (optional) - Flags the user as external - true or false(default)
  ///   - avatar (optional) - Image file for user’s avatar
  ///   - private_profile (optional) - User’s profile is private - true or false
  /// - Returns: returns and observable of User?
  public func putUser(userID: Int, parameters: QueryParameters? = nil) -> Observable<User> {
    let apiRequest = APIRequest(path: Endpoints.user(userID: userID).url, method: .put, parameters: parameters)
    return object(for: apiRequest)
  }

  /// Deletes a user. Available only for administrators. This returns a `204 No Content` status code if the operation was successfully or `404` if the resource was not found.
  /// - Parameters:
  ///   - userID (required): The ID of the user
  ///   - parameters: Query Parameters [String: Any]
  /// - **Query Parameters:**
  ///   - email - Email
  ///   - username - Username
  public func deleteUser(userID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.user(userID: userID).url, method: .delete, parameters: parameters)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func getCurrentUser() -> Observable<User> {
    let apiRequest = APIRequest(path: Endpoints.currentUser.url)
    return object(for: apiRequest)
  }

  public func getStatus() -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.status.url)
    return object(for: apiRequest)
  }

  public func getUsersStatus(userID: Int) -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.usersStatus(userIDOrUsername: "\(userID)").url)
    return object(for: apiRequest)
  }

  public func getUsersStatus(username: String) -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.usersStatus(userIDOrUsername: username).url)
    return object(for: apiRequest)
  }

  public func putStatus(status: CommitStatus) -> Observable<CommitStatus> {
    do {
      let statusData = try JSONEncoder().encode(status)
      let apiRequest = APIRequest(path: Endpoints.status.url, method: .put, data: statusData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func getSSHKeys() -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.sshKeys.url)
    return object(for: apiRequest)
  }

  public func getUsersSSHKeys(userID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.usersSSHKeys(userID: userID).url)
    return object(for: apiRequest)
  }

  public func getSSHKey(keyID: Int) -> Observable<UserKey> {
    let apiRequest = APIRequest(path: Endpoints.sshKey(keyID: keyID).url)
    return object(for: apiRequest)
  }

  public func postSSHKey(key: UserKey) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.sshKeys.url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func postSSHKeyForUser(key: UserKey, userID: Int) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.usersSSHKeys(userID: userID).url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func deleteSSHKey(keyID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.sshKey(keyID: keyID).url, method: .delete, parameters: parameters)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func deleteUsersSSHKey(userID: Int, keyID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersSSHKey(userID: userID, keyID: keyID).url, method: .delete, parameters: parameters)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func getGPGKeys() -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.gpgKeys.url)
    return object(for: apiRequest)
  }

  public func getGPGKey(keyID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.gpgKey(keyID: keyID).url)
    return object(for: apiRequest)
  }

  public func postGPGKey(key: UserKey) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.gpgKeys.url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func deleteGPGKey(keyID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.gpgKey(keyID: keyID).url, method: .delete, parameters: parameters)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func getUsersGPGKeys(userID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKeys(userID: userID).url)
    return object(for: apiRequest)
  }

  public func getGPGKeyForUser(userID: Int, keyID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKey(userID: userID, keyID: keyID).url)
    return object(for: apiRequest)
  }

  public func postUserGPGKey(key: UserKey, userID: Int) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.usersGPGKeys(userID: userID).url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func deleteUsersGPGKey(userID: Int, keyID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKey(userID: userID, keyID: keyID).url, method: .delete, parameters: parameters)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func getEmails() -> Observable<Email> {
    let apiRequest = APIRequest(path: Endpoints.emails.url)
    return object(for: apiRequest)
  }

  public func getEmail(emailID: Int) -> Observable<Email> {
    let apiRequest = APIRequest(path: Endpoints.email(emailID: emailID).url)
    return object(for: apiRequest)
  }

  public func postEmail(email: Email) -> Observable<Email> {
    do {
      let emailData = try JSONEncoder().encode(email)
      let apiRequest = APIRequest(path: Endpoints.emails.url, method: .post, data: emailData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func deleteEmail(emailID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.email(emailID: emailID).url, method: .delete)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func postUsersEmail(email: Email, userID: Int) -> Observable<Email> {
    do {
      let emailData = try JSONEncoder().encode(email)
      let apiRequest = APIRequest(path: Endpoints.usersEmails(userID: userID).url, method: .post, data: emailData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

  public func deleteUsersEmail(userID: Int, emailID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersEmail(userID: userID, emailID: emailID).url, method: .delete)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func blockUser(userID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.blockUser(userID: userID).url, method: .post)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 201
      })
  }

  public func unBlockUser(userID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.unBlockUser(userID: userID).url, method: .post)
    let urlRequest = apiRequest.buildRequest(with: hostURL)!
    return network.response(for: urlRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }

  public func getImpersonationTokens(userID: Int) -> Observable<[ImpersonationToken]> {
    let apiRequest = APIRequest(path: Endpoints.usersImpersonationTokens(userID: userID).url)
    return object(for: apiRequest)
  }

  public func getUsersImpersonationToken(userID: Int, tokenID: Int) -> Observable<[ImpersonationToken]> {
    let apiRequest = APIRequest(path: Endpoints.usersImpersonationToken(userID: userID, impersonationTokenID: tokenID).url)
    return object(for: apiRequest)
  }

  public func postImpersonationToken(token: ImpersonationToken, userID: Int) -> Observable<ImpersonationToken> {
    do {
      let tokenData = try JSONEncoder().encode(token)
      let apiRequest = APIRequest(path: Endpoints.usersImpersonationTokens(userID: userID).url, method: .post, data: tokenData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }

}
