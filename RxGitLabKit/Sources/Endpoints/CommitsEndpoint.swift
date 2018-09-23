//
//  CommitEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class CommitsEndpoint: Endpoint {
  
  enum Endpoints {
    case commits(projectID: String)
    case single(projectID: String, sha: String)
    case references(projectID: String, sha: String)
    case cherryPick(projectID: String, sha: String)

    var url: String {
      switch self {
      case .commits(let projectID):
        return "/projects/\(projectID)/repository/commits"
      case .single(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)"
      case .references(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/refs"
      case .cherryPick(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/cherry_pick"
      }
    }
  }
  
  ///   Get an observable of list of repository commits in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter parameters: Query Parameters - See description
  ///
  /// Query Parameters:
  /// - Optional:
  ///     - **ref_name: String** - The name of a repository branch or tag or if not given the default branch
  ///     - **since: String** - Only commits after or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
  ///
  /// - Returns: An observable of list of repository commits in a project
  public func get(projectID: String, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int?) -> Observable<[Commit]> {
    if page != 1 {
      
    }
    let getRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .get, parameters: parameters)
    return object(for: getRequest)
  }
  

  public func getSingle(projectID: String, sha: String) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.single(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  public func getReferences(projectID: String, sha: String) -> Observable<[Reference]> {
    let apiRequest = APIRequest(path: Endpoints.references(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  

  public func cherryPick(projectID: String, sha: String) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.cherryPick(projectID: projectID, sha: sha).url, method: .post)
    return object(for: apiRequest)
  }
  
}
