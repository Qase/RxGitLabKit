//
//  MembersEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class MembersEndpointGroup: EndpointGroup {

  public enum Endpoints {
    case groupMember(groupID: Int, userID: Int)
    case groupMembers(groupID: Int)
    case allGroupMembers(groupID: Int)

    case projectMember(projectID: Int, userID: Int)
    case projectMembers(projectID: Int)
    case allProjectMembers(projectID: Int)

    var url: String {
      switch self {
      case .groupMember(let groupID, let userID):
        return "/groups/\(groupID)/members/\(userID)"
      case .groupMembers(let groupID):
        return "/groups/\(groupID)/members"
      case .allGroupMembers(let groupID):
        return "/groups/\(groupID)/members/all"
      case .projectMember(let projectID, let userID):
        return "/projects/\(projectID)/members/\(userID)"
      case .projectMembers(let projectID):
        return "/projects/\(projectID)/members"
      case .allProjectMembers(let projectID):
        return "/projects/\(projectID)/members/all"
      }
    }
  }

  public func get(groupID: Int, parameters: QueryParameters? = nil) -> Observable<[Member]> {
    let getRequest = APIRequest(path: Endpoints.groupMembers(groupID: groupID).url, parameters: parameters)

    return object(for: getRequest)
  }

  public func get(projectID: Int, parameters: QueryParameters? = nil ) -> Observable<[Member]> {
    let getRequest = APIRequest(path: Endpoints.projectMembers(projectID: projectID).url, parameters: parameters)
    return object(for: getRequest)
  }

  public func getSingle(groupID: Int, userID: Int, parameters: QueryParameters? = nil) -> Observable<Member> {
    let getRequest = APIRequest(path: Endpoints.groupMember(groupID: groupID, userID: userID).url, parameters: parameters)
    return object(for: getRequest)
  }

  public func getSingle(projectID: Int, userID: Int, parameters: QueryParameters? = nil) -> Observable<Member> {
    let getRequest = APIRequest(path: Endpoints.projectMember(projectID: projectID, userID: userID).url, parameters: parameters)
    return object(for: getRequest)
  }

  /// Gets a list of group members viewable by the authenticated user, including inherited members through ancestor groups. Returns multiple times the same user (with different member attributes) when the user is a member of the project/group and of one or more ancestor group.
  public func getAll(groupID: Int, parameters: QueryParameters? = nil) -> Observable<[Member]> {
    let getRequest = APIRequest(path: Endpoints.allGroupMembers(groupID: groupID).url, parameters: parameters)
    return object(for: getRequest)
  }

  /// Gets a list of project members viewable by the authenticated user, including inherited members through ancestor groups. Returns multiple times the same user (with different member attributes) when the user is a member of the project/group and of one or more ancestor group.
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the

  public func getAll(projectID: Int, parameters: QueryParameters? = nil) -> Observable<[Member]> {
    let getRequest = APIRequest(path: Endpoints.allProjectMembers(projectID: projectID).url, parameters: parameters)
    return object(for: getRequest)
  }
}
