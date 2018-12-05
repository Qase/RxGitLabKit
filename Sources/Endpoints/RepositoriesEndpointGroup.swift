//
//  RepositoriesEnpointGroup.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 17/11/2018.
//

import Foundation
import RxSwift

public class RepositoriesEndpointGroup: EndpointGroup {
  
  internal enum Endpoints {
    case tree(projectID: Int)
    case blobs(projectID: Int, sha: String)
    case blobsRaw(projectID: Int, sha: String)
    case archive(projectID: Int, format: String)
    case compare(projectID: Int)
    case contributors(projectID: Int)
    case mergeBase(projectID: Int)
    case files(projectID: Int, filePath: String)
    case filesRaw(projectID: Int, filePath: String)
    case submodules(projectID: Int, submodule: String)
    
    var url: String {
      switch self {
      case .tree(let projectID):
        return "/projects/\(projectID)/repository/tree"
      case .blobs(let projectID, let sha):
        return "/projects/\(projectID)/repository/blobs/\(sha)"
      case .blobsRaw(let projectID, let sha):
        return "/projects/\(projectID)/repository/blobs/\(sha)/raw"
      case .archive(let projectID, let format):
        return "/projects/\(projectID)/repository/archive.\(format)"
      case .compare(let projectID):
        return "/projects/\(projectID)/repository/compare"
      case .contributors(let projectID):
        return "/projects/\(projectID)/repository/contributors"
      case .mergeBase(let projectID):
        return "/projects/\(projectID)/repository/merge_base"
      case .files(let projectID, let filePath):
        return "/projects/\(projectID)/repository/files/\(filePath)"
      case .filesRaw(let projectID, let filePath):
        return "/projects/\(projectID)/repository/files/\(filePath)/raw"
      case .submodules(let projectID, let submodule):
        return "/projects/\(projectID)/repository/submodules/\(submodule)"
      }
    }
  }
  
  
  /// Get a list of repository files and directories in a project. This endpoint can be accessed without authentication if the repository is publicly accessible.
  ///
  /// This command provides essentially the same functionality as the `git ls-tree` command. For more information, see the section Tree Objects in the Git internals documentation.
  ///
  /// - Parameter projectID: The ID or URL-encoded path of the project
  ///
  /// **Query Parameters:**
  ///   - id (required) - The ID or URL-encoded path of the project owned by the authenticated user
  ///   - path (optional) - The path inside repository. Used to get content of subdirectories
  ///   - ref (optional) - The name of a repository branch or tag or if not given the default branch
  ///   - recursive (optional) - Boolean value used to get a recursive tree (false by default)
  ///   - per_page (optional) - Number of results to show per page. If not specified, defaults to `20`
  /// - Returns: An observable of TreeNodes
  public func getTree(projectID: Int) -> Paginator<TreeNode> {
    let apiRequest = APIRequest(path: Endpoints.tree(projectID: projectID).url)
    return Paginator(communicator: hostCommunicator, apiRequest: apiRequest)
  }
  
  public func getBlob(projectID: Int, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.blobs(projectID: projectID, sha: sha).url)
    return data(for: apiRequest)
  }
  
  public func getBlobRaw(projectID: Int, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.blobsRaw(projectID: projectID, sha: sha).url)
    return data(for: apiRequest)
  }
  
  public func getArchive(projectID: Int, format: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.archive(projectID: projectID, format: format).url)
    return data(for: apiRequest)
  }
  
  public func getComparison(projectID: Int, from: String, to: String) -> Observable<Comparison> {
    let apiRequest = APIRequest(path: Endpoints.compare(projectID: projectID).url, parameters: ["from" : from, "to" : to])
    return object(for: apiRequest)
  }
  
  public func getContributors(projectID: Int) -> Paginator<Contributor> {
    let apiRequest = APIRequest(path: Endpoints.contributors(projectID: projectID).url)
    return Paginator(communicator: hostCommunicator, apiRequest: apiRequest)
  }
  
  public func getMergeBase(projectID: Int, refs: [String]) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.mergeBase(projectID: projectID).url, parameters: ["refs" : refs])
    
    return object(for: apiRequest)
  }
  
  public func getFileInfo(projectID: Int, filePath: String, ref: String) -> Observable<FileInfo> {
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, parameters: ["ref": ref])
    return object(for: apiRequest)
  }
  
  public func getFile(projectID: Int, filePath: String, ref: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.filesRaw(projectID: projectID, filePath: filePath).url, parameters: ["ref": ref])
    return data(for: apiRequest)
  }
  
  public func postFile(file: FileInfo, projectID: Int, filePath: String) -> Observable<FileInfo> {
    guard let data = try? JSONEncoder().encode(file) else {
      return Observable.error(ParsingError.encoding(message: "New Project could not be encoded"))
    }
    
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .post, data: data)
    return object(for: apiRequest)
  }
  
  public func putFile(file: FileInfo, projectID: Int, filePath: String) -> Observable<FileInfo> {
    guard let data = try? JSONEncoder().encode(file) else {
      return Observable.error(ParsingError.encoding(message: "New Project could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .put, data: data)
    return object(for: apiRequest)
  }
  
  public func deleteFile(file: FileInfo, projectID: Int, filePath: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .delete)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }
}
