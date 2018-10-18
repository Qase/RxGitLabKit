//
//  RepositoriesEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 14/08/2018.
//

import Foundation
import RxSwift

public class RepositoriesEndpointGroup: EndpointGroup {

  public enum Endpoints {
    case tree(id: String)
    case blob(id: String, sha: String)
    case rawBlob(id: String, sha: String)
    case archive(id: String)
    case compare(id: String)
    case contributors(id: String)
    
    var path: String {
      switch self {
      case .tree(let id):
        return "/projects/\(id)/repository/tree"
      case .blob(let id, let sha):
        return "/projects/\(id)/repository/blobs/\(sha)"
      case .rawBlob(let id, let sha):
        return "/projects/\(id)/repository/blobs/\(sha)/raw"
      case .archive(let id):
        return "/projects/\(id)/repository/archive"
      case .compare(let id):
        return "/projects/\(id)/repository/compare"
      case .contributors(let id):
        return "/projects/\(id)/repository/contributors"
      }
    }
  }
  
  public func tree(projectID: String, parameters: QueryParameters? = nil) -> Observable<[TreeNode]> {
    let apiRequest = APIRequest(path: Endpoints.tree(id: projectID).path, parameters: parameters)
    return object(for: apiRequest)
  }
  
  public func blob(projectID: String, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.blob(id: projectID, sha: sha).path)
    return object(for: apiRequest)
  }
  
  public func rawBlob(projectID: String, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.rawBlob(id: projectID, sha: sha).path)
    return object(for: apiRequest)
  }
  
  public func archive(projectID: String, parameters: QueryParameters? = nil) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.archive(id: projectID).path)
    return object(for: apiRequest)
  }
  
  public func compare(projectID: String, parameters: QueryParameters) -> Observable<Data> {
    if parameters["from"] == nil || parameters["to"] == nil {
      return Observable.error(HTTPError.invalidRequest(message: "`from` and `to` commit SHA or branch name is required"))
    }
    let apiRequest = APIRequest(path: Endpoints.compare(id: projectID).path, parameters: parameters)
    return object(for: apiRequest)
  }
  
  public func contributors(projectID: String, parameters: QueryParameters? = nil) -> Observable<[Contributor]> {
    let apiRequest = APIRequest(path: Endpoints.contributors(id: projectID).path, parameters: parameters)
    return object(for: apiRequest)
  }
  
}
