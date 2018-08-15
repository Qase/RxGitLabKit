//
//  CommitEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

class CommitsEndpoint: Endpoint {
  
  enum Endpoints {
    case commits(id: String)
    case single(id: String, sha: String)
    case references(id: String, sha: String)
    case cherryPick(id: String, sha: String)

    var url: String {
      switch self {
      case .commits(let id):
        return "/projects/\(id)/repository/commits"
      case .single(let id, let sha):
        return "/projects/\(id)/repository/commits/\(sha)"
      case .references(let id, let sha):
        return "/projects/\(id)/repository/commits/\(sha)/refs"
      case .cherryPick(let id, let sha):
        return "/projects/\(id)/repository/commits/\(sha)/cherry_pick"
      }
    }
  }
  
  private func path(endpoint: Endpoints) -> String {
    return endpoint.url
  }
  
  private func path(endpoint: Endpoints, projectID: String, sha: String? = nil) -> String {
    return endpoint.url
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
  func get(projectID: String, parameters: QueryParameters? = nil) -> Observable<[Commit]> {
    let getRequest = APIRequest(path: Endpoints.commits(id: projectID).url, method: .get, parameters: parameters)
    return object(for: getRequest)
  }
  

  func getSingle(projectID: String, sha: String) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.single(id: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  func getReferences(projectID: String, sha: String) -> Observable<[Reference]> {
    let apiRequest = APIRequest(path: Endpoints.references(id: projectID,sha: sha).url)
    return object(for: apiRequest)
  }
  

  func cherryPick(projectID: String, sha: String) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.cherryPick(id: projectID, sha: sha).url, method: .post)
    return object(for: apiRequest)
  }
  
}
