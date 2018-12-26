//
//  UsersEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

/**
 This EndpointGroup communicates with [Users API](https://docs.gitlab.com/ee/api/users.html)
 */
public class UsersEndpointGroup: EndpointGroup {
  
  internal enum Endpoints {
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
    let paginator = Paginator<User>(communicator: hostCommunicator, apiRequest: apiRequest, perPage: perPage)
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
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   Gets currently authenticated user.
   - Returns: An `Observable` of a `User`
   */
  public func getCurrentUser() -> Observable<User?> {
    let apiRequest = APIRequest(path: Endpoints.currentUser.url)
    return object(for: apiRequest)
      .catchErrorJustReturn(nil)
      .debug()
  }
  
  /**
   User status
   
   Get the status of the currently signed in user.
   - Returns: An `Observable` of a `UserStatus`
   */
  public func getStatus() -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.status.url)
    return object(for: apiRequest)
  }
  
  /**
   Get the status of a user
   - Parameter userID: The id of the user to get a status of
   - Returns: An `Observable` of a `UserStatus`
   */
  public func getUsersStatus(userID: Int) -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.usersStatus(userIDOrUsername: "\(userID)").url)
    return object(for: apiRequest)
  }
  /**
   Get the status of a user
   
   - Parameter username: The username of the user to get a status of
   - Returns: An `Observable` of a `UserStatus`
   */
  public func getUsersStatus(username: String) -> Observable<UserStatus> {
    let apiRequest = APIRequest(path: Endpoints.usersStatus(userIDOrUsername: username).url)
    return object(for: apiRequest)
  }
  
  /**
   Set user status
   
   Set the status of the current user.
   
   - Parameter status: UserStatus
   - Returns: An `Observable` of a `UserStatus`
   */
  public func putStatus(status: UserStatus) -> Observable<UserStatus> {
    do {
      let statusData = try JSONEncoder().encode(status)
      let apiRequest = APIRequest(path: Endpoints.status.url, method: .put, data: statusData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   List SSH keys
   
   Get a list of currently authenticated user’s SSH keys.
   
   - Returns: An `Observable` of a list of `UserKey`
   */
  public func getSSHKeys() -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.sshKeys.url)
    return object(for: apiRequest)
  }
  
  /**
   List SSH keys for user
   
   Get a list of a specified user’s SSH keys.
   - Parameter userID: id of specified user
   - Returns: An `Observable` of a list of `UserKey`
   */
  public func getUsersSSHKeys(userID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.usersSSHKeys(userID: userID).url)
    return object(for: apiRequest)
  }
  
  /**
   Single SSH key
   
   Get a single key.
   
   - Parameter keyID: The ID of an SSH key
   - Returns: An `Observable` of a `UserKey`
   */
  public func getSSHKey(keyID: Int) -> Observable<UserKey> {
    let apiRequest = APIRequest(path: Endpoints.sshKey(keyID: keyID).url)
    return object(for: apiRequest)
  }
  
  /**
   Add SSH key
   
   Creates a new key owned by the currently authenticated user.
   
   - Parameter key: UserKey (`title` and `key` is required)
   - Returns: An `Observable` of a `UserKey`
   */
  public func postSSHKey(key: UserKey) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.sshKeys.url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  /**
   Add SSH key
   
   Creates a new key owned by the currently authenticated user.
   
   - Parameter key: UserKey (`title` and `key` is required)
   - Returns: An `Observable` of a `UserKey`
   */
  public func postSSHKeyForUser(key: UserKey, userID: Int) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.usersSSHKeys(userID: userID).url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Delete SSH key for current user
   
   Deletes key owned by currently authenticated user. This returns a `204 No Content` status code if the operation was successfully or `404` if the resource was not found.
   
   - Parameter keyID: SSH key ID
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteSSHKey(keyID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.sshKey(keyID: keyID).url, method: .delete)
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   Delete SSH key for given user
   
   Deletes key owned by a specified user. Available only for admin.
   
   - Parameter userID: id of specified user
   - Parameter keyID: SSH key ID
   
   - Returns: An `Observable` of a `UserKey`
   */
  public func deleteUsersSSHKey(userID: Int, keyID: Int, parameters: QueryParameters? = nil) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersSSHKey(userID: userID, keyID: keyID).url, method: .delete, parameters: parameters)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   List all GPG keys
   
   Get a list of currently authenticated user’s GPG keys.
   
   - Returns: An `Observable` of a list of `UserKey`
   */
  public func getGPGKeys() -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.gpgKeys.url)
    return object(for: apiRequest)
  }
  
  /**
   Get a specific GPG key
   
   Get a specific GPG key of currently authenticated user.
   
   - Parameter keyID: The ID of the GPG key
   - Returns: An `Observable` of a `UserKey`
   */
  public func getGPGKey(keyID: Int) -> Observable<UserKey> {
    let apiRequest = APIRequest(path: Endpoints.gpgKey(keyID: keyID).url)
    return object(for: apiRequest)
  }
  
  /**
   Add a GPG key
   
   Creates a new GPG key owned by the currently authenticated user.
   
   - Parameter key: UserKey (`key` is required)
   - Returns: An `Observable` of a `UserKey`
   */
  public func postGPGKey(key: UserKey) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.gpgKeys.url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Delete a GPG key
   
   Delete a GPG key owned by currently authenticated user.
   
   - Parameter keyID: The ID of the GPG key
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteGPGKey(keyID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.gpgKey(keyID: keyID).url, method: .delete)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   List all GPG keys for given user
   
   Get a list of a specified user’s GPG keys. Available only for admins.
   
   - Parameter userID: The ID of the user
   - Returns: An `Observable` of a `UserKey`
   */
  public func getUsersGPGKeys(userID: Int) -> Observable<[UserKey]> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKeys(userID: userID).url)
    return object(for: apiRequest)
  }
  
  /**
   Get a specific GPG key for a given user
   
   Get a specific GPG key for a given user. Available only for admins.
   
   - Parameter userID: The ID of the user
   - Parameter keyID: The ID of the GPG key
   - Returns: An `Observable` of a `UserKey`
   */
  public func getGPGKeyForUser(userID: Int, keyID: Int) -> Observable<UserKey> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKey(userID: userID, keyID: keyID).url)
    return object(for: apiRequest)
  }
  
  /**
   Add a GPG key for a given user
   
   Create new GPG key owned by the specified user. Available only for admins.
   
   - Parameter key: UserKey (`key` is required)
   - Parameter userID: The ID of the user
   - Returns: An `Observable` of a `UserKey`
   */
  public func postUserGPGKey(key: UserKey, userID: Int) -> Observable<UserKey> {
    do {
      let keyData = try JSONEncoder().encode(key)
      let apiRequest = APIRequest(path: Endpoints.usersGPGKeys(userID: userID).url, method: .post, data: keyData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Delete a GPG key for a given user
   
   Delete a GPG key owned by a specified user. Available only for admins.
   
   - Parameter keyID: The ID of the GPG key
   - Parameter userID: The ID of the user
   
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteUsersGPGKey(userID: Int, keyID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersGPGKey(userID: userID, keyID: keyID).url, method: .delete)
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   List emails
   
   Get a list of currently authenticated user’s emails.
   
   - Returns: An `Observable` of a list of `Email`
   */
  public func getEmails() -> Observable<[Email]> {
    let apiRequest = APIRequest(path: Endpoints.emails.url)
    return object(for: apiRequest)
  }
  
  /**
   List emails for user
   
   Get a list of a specified user’s emails. Available only for admin
   
   - Returns: An `Observable` of a list of `Email`
   */
  public func getUserEmails(userID: Int) -> Observable<[Email]> {
    let apiRequest = APIRequest(path: Endpoints.usersEmails(userID: userID).url)
    return object(for: apiRequest)
  }
  
  /**
   Single email
   
   Get a single email.
   
   - Parameter emailID - ID of an email
   - Returns: An `Observable` of a `Email`
   */
  public func getEmail(emailID: Int) -> Observable<Email> {
    let apiRequest = APIRequest(path: Endpoints.email(emailID: emailID).url)
    return object(for: apiRequest)
  }
  
  /**
   Add email
   
   Creates a new email owned by the currently authenticated user.
   
   - Parameter email - Email (`email` is required)
   - Returns: An `Observable` of a `Email`
   */
  public func postEmail(email: Email) -> Observable<Email> {
    do {
      let emailData = try JSONEncoder().encode(email)
      let apiRequest = APIRequest(path: Endpoints.emails.url, method: .post, data: emailData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Delete email for current user
   
   Deletes email owned by currently authenticated user.
   
   - Parameter key - UserKey (`title` and `key` is required)
   
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteEmail(emailID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.email(emailID: emailID).url, method: .delete)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   Add email for user
   
   Create new email owned by specified user. Available only for admin
   
   - Parameter email - Email (`email` is required)
   - Parameter userID: The ID of the user
   
   - Returns: An `Observable` of a `UserKey`
   */
  public func postUsersEmail(email: Email, userID: Int) -> Observable<Email> {
    do {
      let emailData = try JSONEncoder().encode(email)
      let apiRequest = APIRequest(path: Endpoints.usersEmails(userID: userID).url, method: .post, data: emailData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Delete email for given user
   
   Deletes email owned by a specified user. Available only for admin.
   
   - Parameter userID: The ID of the user
   - Parameter emailID: The ID of the email
   
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteUsersEmail(userID: Int, emailID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersEmail(userID: userID, emailID: emailID).url, method: .delete)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   Block user
   
   Blocks the specified user. Available only for admin.
   
   - Parameter userID: The ID of the user
   - Returns: An `Observable` of a `Bool` - `true` if blocking was successful
   */
  public func blockUser(userID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.blockUser(userID: userID).url, method: .post)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 201
      })
  }
  
  /**
   Unblock user
   
   Unlocks the specified user. Available only for admin.
   
   - Parameter userID: The ID of the user
   - Returns: An `Observable` of a `Bool` - `true` if unblocking was successful
   */
  public func unBlockUser(userID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.unBlockUser(userID: userID).url, method: .post)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 201
      })
  }
  
  /**
   Get all impersonation tokens of a user
   
   Requires admin permissions.
   
   It retrieves every impersonation token of the user. Use the pagination parameters `page` and `per_page` to restrict the list of impersonation tokens.
   
   - Parameter userID: The ID of the user
   - Parameter parameters: Query Parameters - See description
   
   **Optinal Query Parameters:**
   - **state: String** - filter tokens based on state (`all`, `active`, `inactive`)
   
   - Returns: An `Observable` of a list of `ImpersonationToken`
   */
  public func getImpersonationTokens(userID: Int, parameters: QueryParameters?) -> Observable<[ImpersonationToken]> {
    let apiRequest = APIRequest(path: Endpoints.usersImpersonationTokens(userID: userID).url)
    return object(for: apiRequest)
  }
  
  /**
   Get an impersonation token of a user
   
   Requires admin permissions.
   
   It shows a user’s impersonation token.
   
   - Parameter userID: The ID of the user
   - Parameter tokenID: The ID of the impersonation token
   
   - Returns: An `Observable` of a `UserKey`
   */
  public func getUsersImpersonationToken(userID: Int, tokenID: Int) -> Observable<[ImpersonationToken]> {
    let apiRequest = APIRequest(path: Endpoints.usersImpersonationToken(userID: userID, impersonationTokenID: tokenID).url)
    return object(for: apiRequest)
  }
  
  /**
   Create an impersonation token
   
   Requires admin permissions.
   
   Token values are returned once. Make sure you save it - you won’t be able to access it again.
   
   It creates a new impersonation token. Note that only administrators can do this. You are only able to create impersonation tokens to impersonate the user and perform both API calls and Git reads and writes. The user will not see these tokens in their profile settings page.
   
   - Parameter token - ImpersonationToken (`name` and `scopes` is required)
   - Parameter userID: The ID of the user
   
   - Returns: An `Observable` of a `UserKey`
   */
  public func postImpersonationToken(token: ImpersonationToken, userID: Int) -> Observable<ImpersonationToken> {
    do {
      let tokenData = try JSONEncoder().encode(token)
      let apiRequest = APIRequest(path: Endpoints.usersImpersonationTokens(userID: userID).url, method: .post, data: tokenData)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Revoke an impersonation token
   
   Requires admin permissions.
   
   It revokes an impersonation token.
   
   - Parameter userID: The ID of the user
   - Parameter tokenID: The ID of the impersonation token
   
   - Returns: An `Observable` of a `Bool` - `true` if the deletion was successful
   */
  public func deleteImpersonationToken(userID: Int, tokenID: Int) -> Observable<Bool> {
    let apiRequest = APIRequest(path: Endpoints.usersImpersonationToken(userID: userID, impersonationTokenID: tokenID).url, method: .delete)
    
    return response(for: apiRequest)
      .map({ ( response, data) -> Bool in
        return response.statusCode == 204
      })
  }
  
  /**
   Get user activities (admin only)
   
   Note: This API endpoint is only available on 8.15 (EE) and 9.1 (CE) and above.
   
   Get the last activity date for all users, sorted from oldest to newest.
   
   The activities that update the timestamp are:
   - Git HTTP/SSH activities (such as clone, push)
   - User logging in into GitLab
   
   By default, it shows the activity for all users in the last 6 months, but this can be amended by using the `from` parameter.
   
   - Parameter userID: The ID of the user
   - Parameter tokenID: The ID of the impersonation token
   
   - Returns: An `Observable` of a list of `Activity`
   */
  public func getUserActivities(from: Date? = nil) -> Observable<[Activity]> {
    var parameters: QueryParameters? = nil
    if let from = from {
      parameters = ["from" : from.asyyyyMMddString]
    }
    let apiRequest = APIRequest(path: Endpoints.activities.url, parameters: parameters)
    return object(for: apiRequest)
  }
}
