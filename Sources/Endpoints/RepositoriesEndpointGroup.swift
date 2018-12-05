//
//  RepositoriesEnpointGroup.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 17/11/2018.
//

import Foundation
import RxSwift

/**
 This EndpointGroup communicates with [Repositories API](https://docs.gitlab.com/ee/api/repositories.html)
 */
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
  
  /**
   Get a list of repository files and directories in a project. This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   This command provides essentially the same functionality as the `git ls-tree` command. For more information, see the section Tree Objects in the Git internals documentation.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter parameters: See Query Parameters in the description
   
   **Optional Query Parameters:**
   - **path: String** - The path inside repository. Used to get content of subdirectories
   - **ref: String** - The name of a repository branch or tag or if not given the default branch
   - **recursive: String** - Boolean value used to get a recursive tree (`false` by default)
   - **per_page: Int** - Number of results to show per page. If not specified, defaults to `20`
   - Returns: An `Observable` of `TreeNode`s
   */
  public func getTree(projectID: Int, parameters: QueryParameters? = nil) -> Paginator<TreeNode> {
    let apiRequest = APIRequest(path: Endpoints.tree(projectID: projectID).url, parameters: parameters)
    return Paginator(communicator: hostCommunicator, apiRequest: apiRequest)
  }
  
  /**
   Get a blob from repository
   
   Allows you to receive information about blob in repository like size and content. Note that blob content is Base64 encoded. This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   - Parameters:
     - projectID: The ID or URL-encoded path of the project owned by the authenticated user
     - sha: The blob SHA
   - Returns: An `Observable` of `Data`
  */
  public func getBlob(projectID: Int, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.blobs(projectID: projectID, sha: sha).url)
    return data(for: apiRequest)
  }
  
  /**
   Raw blob content
   Get the raw file contents for a blob by blob SHA. This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   - Parameters:
     - projectID: The ID or URL-encoded path of the project owned by the authenticated user
     - sha: The blob SHA
   - Returns: An `Observable` of `Data`
  */
  public func getBlobRaw(projectID: Int, sha: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.blobsRaw(projectID: projectID, sha: sha).url)
    return data(for: apiRequest)
  }
  
  /**
   Get file archive
   
   Get an archive of the repository. This endpoint can be accessed without authentication if the repository is publicly accessible.

   - Parameters:
    - projectID: The ID or URL-encoded path of the project owned by the authenticated user
     - format: an optional suffix for the archive format. Default is `tar.gz`. Options are `tar.gz`, `tar.bz2`, `tbz`, `tbz2`, `tb2`, `bz2`, `tar`, and `zip`. For example, specifying `archive.zip` would send an archive in ZIP format.
   - Returns: An `Observable` of `Data`
   */
  public func getArchive(projectID: Int, format: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.archive(projectID: projectID, format: format).url)
    return data(for: apiRequest)
  }
  
  /**
   Compare branches, tags or commits
   
   This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   - Parameters:
    - from: The commit SHA or branch name
    - to: The commit SHA or branch name
   
   **Optional Query Parameters:**
   - **straight: Boolean** - Limit by visibility public, internal, or private
   
   - Returns: An `Observable` of list of `Comparison`
   */
  public func getComparison(projectID: Int, from: String, to: String, parameters: QueryParameters? = [:]) -> Observable<Comparison> {
    var newParameters = parameters ?? [String: Any]()
    newParameters["from"] = from
    newParameters["to"] = to
    let apiRequest = APIRequest(path: Endpoints.compare(projectID: projectID).url, parameters: newParameters)
    return object(for: apiRequest)
  }
  
  /**
   Contributors
   
   Get repository contributors list. This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter parameters: See Query Parameters in the description
   
   ***Optional Query Parameters:**
   - **order_by: String** - Return contributors ordered by `name`, `email`, or `commits` (orders by commit date) fields. Default is `commits`
   - **sort: String** - Return contributors sorted in `asc` or `desc! order. Default is `asc`.
 
   - Returns: An `Observable` of list of `Contributor`
   */
  public func getContributors(projectID: Int, parameters: QueryParameters? = nil) -> Paginator<Contributor> {
    let apiRequest = APIRequest(path: Endpoints.contributors(projectID: projectID).url)
    return Paginator(communicator: hostCommunicator, apiRequest: apiRequest)
  }
  
  /**
   Merge Base
   
   Get the common ancestor for 2 refs (commit SHAs, branch names or tags).

   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter refs: The refs to find the common ancestor of, multiple refs can be passed
   
   - Returns: An `Observable` of list of `Commit`
   */
  public func getMergeBase(projectID: Int, refs: [String]) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.mergeBase(projectID: projectID).url, parameters: ["refs" : refs])
    
    return object(for: apiRequest)
  }
  
  /**
   Get file from repository
   
   Allows you to receive information about file in repository like name, size, content. Note that file content is Base64 encoded. This endpoint can be accessed without authentication if the repository is publicly accessible.
   
   - Parameters:
      - projectID: The ID or URL-encoded path of the project
      - file_path: Url encoded full path to new file. Ex. lib%2Fclass%2Erb
      - ref: The name of branch, tag or commit
   
   - Returns: An `Observable` of list of `FileInfo`
   */
  public func getFileInfo(projectID: Int, filePath: String, ref: String) -> Observable<FileInfo> {
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, parameters: ["ref": ref])
    return object(for: apiRequest)
  }
  
  /**
   Get raw file from repository
  
   - Parameters:
     - projectID: The ID or URL-encoded path of the project
     - file_path: Url encoded full path to new file. Ex. lib%2Fclass%2Erb
     - ref: The name of branch, tag or commit
   
   - Returns: An `Observable` of list of `FileInfo`
   */
  public func getFile(projectID: Int, filePath: String, ref: String) -> Observable<Data> {
    let apiRequest = APIRequest(path: Endpoints.filesRaw(projectID: projectID, filePath: filePath).url, parameters: ["ref": ref])
    return data(for: apiRequest)
  }
  
  /**
   Create new file in repository
   
   This allows you to create a single file. For creating multiple files with a single request see the [commits API](https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions).
   
   - Parameters:
     - file: File containing data
     - projectID: The ID or URL-encoded path of the project
     - filePath: Url encoded full path to new file. Ex. lib%2Fclass%2Erb
   
   - Returns: An `Observable` of list of `File`
   */
  public func postFile(file: File, projectID: Int, filePath: String) -> Observable<File> {
    guard let data = try? JSONEncoder().encode(file) else {
      return Observable.error(ParsingError.encoding(message: "New File could not be encoded"))
    }
    
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .post, data: data)
    return object(for: apiRequest)
  }
  
  /**
   Update existing file in repository
   
   This allows you to update a single file. For updating multiple files with a single request see the [commits API](https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions).
   If the commit fails for any reason we return a 400 error with a non-specific error message. Possible causes for a failed commit include: - the `file_path` contained `/../` (attempted directory traversal); - the new file contents were identical to the current file contents, i.e. the user tried to make an empty commit; - the branch was updated by a Git push while the file edit was in progress.
   
   Currently gitlab-shell has a boolean return code, preventing GitLab from specifying the error.
   
   - Parameters:
     - file: File containing data
     - projectID: The ID or URL-encoded path of the project
     - filePath: Url encoded full path to new file. Ex. lib%2Fclass%2Erb
   
   - Returns: An `Observable` of list of `File`
   */
  public func putFile(file: File, projectID: Int, filePath: String) -> Observable<FileInfo> {
    guard let data = try? JSONEncoder().encode(file) else {
      return Observable.error(ParsingError.encoding(message: "Updated File could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .put, data: data)
    return object(for: apiRequest)
  }
  
  /**
   Delete existing file in repository
   This allows you to delete a single file. For deleting multiple files with a singleh request see the [commits API](https://docs.gitlab.com/ee/api/commits.html#create-a-commit-with-multiple-files-and-actions).
   
   - Parameters:
     - projectID: The ID or URL-encoded path of the project
     - file_path: Url encoded full path to new file. Ex. lib%2Fclass%2Erb
     - ref: The name of branch, tag or commit
   
   - Returns: An `Observable` of list of `FileInfo`
   */
  public func deleteFile(file: File, projectID: Int, filePath: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.files(projectID: projectID, filePath: filePath).url, method: .delete)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }
}
