//
//  Projects.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 23/08/2018.
//

import Foundation
import RxSwift

public class ProjectsEnpointGroup: EndpointGroup {
  
  enum Endpoints {
    case project(projectID: String)
    case projects
    case userProjects(userID: String)
    case projectUsers(projectID: String)
    case createUserProject(userID: String)
    case fork(projectID: String)
    case forks(projectID: String)
    case star(projectID: String)
    case unstar(projectID: String)
    case languages(projectID: String)
    case archive(projectID: String)
    case unarchive(projectID: String)
    case uploads(projectID: String)
    case share(projectID: String)
    case shareGroup(projectID: String, groupID: String)
    case hook(projectID: String, hookID: String)
    case hooks(projectID: String)
    case forkRelationship(projectID: String, forkedFromID: String)
    case housekeeping(projectID: String)
    case pushRule(projectID: String)
    case transfer(projectID: String)
    case mirrorPull(projectID: String)
    case snapshot(projectID: String)
    
    var url: String {
      switch self {
      case .project(let projectID):
          return "/projects/\(projectID)"
      case .projects:
        return "/projects"
      case .userProjects(let userID):
        return "/users/\(userID)"
      case .projectUsers(let projectID):
        return "/projects/\(projectID)/users"
      case .createUserProject(let userID):
        return "/projects/user/\(userID)"
      case .fork(let projectID):
        return "/projects/\(projectID)/fork"
      case .forks(let projectID):
        return "/projects/\(projectID)/forks"
      case .forkRelationship(let projectID, let forkedFromID):
        return "/projects/\(projectID)/fork(\(forkedFromID)"
      case .star(let projectID):
        return "/projects/\(projectID)/star"
      case .unstar(let projectID):
        return "/projects/\(projectID)/unstar"
      case .languages(let projectID):
        return "/projects/\(projectID)/languages"
      case .archive(let projectID):
        return "/projects/\(projectID)/archive"
      case .unarchive(let projectID):
        return "/projects/\(projectID)/unarchive"
      case .uploads(let projectID):
        return "/projects/\(projectID)/uploads"
      case .share(let projectID):
        return "/projects/\(projectID)/share"
      case .shareGroup(let projectID, let groupID):
        return "/projects/\(projectID)/share/\(groupID)"
      case .hook(let projectID, let hookID):
        return "/projects/\(projectID)/hooks/\(hookID)"
      case .hooks(let projectID):
        return "/projects/\(projectID)/hooks"
      case .housekeeping(let projectID):
        return "/projects/\(projectID)/housekeeping"
      case .pushRule(let projectID):
        return "/projects/\(projectID)/push_rule"
      case .transfer(let projectID):
        return "/projects/\(projectID)/transfer"
      case .mirrorPull(let projectID):
        return "/projects/\(projectID)/mirror/pull"
      case .snapshot(let projectID):
        return "/projects/\(projectID)/snapshot"
      }
    }
  }

  // TODO: Add endpoind methods
  
}
