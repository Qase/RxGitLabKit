//
//  MembersEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import RxSwift

public class MembersEndpointGroup: EndpointGroup {
  
  enum Endpoints {
    case groupMember(groupID: String, userID: String)
    case groupMembers(groupID: String)
    case allGroupMembers(groupID: String)
    
    case projectMember(projectID: String, userID: String)
    case projectMembers(projectID: String)
    case allProjectMembers(projectID: String)

    
    var url: String {
      switch self {
      case .groupMember(let groupID, let userID):
        return "/groups/\(groupID)/members\(userID)"
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

}
