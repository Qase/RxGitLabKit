//
//  CommitEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

/**
 This EndpointGroup communicates with [Commits API](https://docs.gitlab.com/ee/api/commits.html)
 */
public class CommitsEndpointGroup: EndpointGroup {
  internal enum Endpoints {
    case commits(projectID: Int)
    case single(projectID: Int, sha: String)
    case references(projectID: Int, sha: String)
    case cherryPick(projectID: Int, sha: String)
    case revert(projectID: Int, sha: String)
    case diff(projectID: Int, sha: String)
    case comments(projectID: Int, sha: String)
    case statusesList(projectID: Int, sha: String)
    case statuses(projectID: Int, sha: String)
    case mergeRequests(projectID: Int, sha: String)
    
    public var url: String {
      switch self {
      case let .commits(projectID):
        return "/projects/\(projectID)/repository/commits"
      case let .single(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)"
      case let .references(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/refs"
      case let .cherryPick(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/cherry_pick"
      case let .revert(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/revert"
      case let .diff(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/diff"
      case let .comments(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/comments"
      case let .statusesList(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/statuses"
      case let .statuses(projectID, sha):
        return "/projects/\(projectID)/statuses/\(sha)"
      case let .mergeRequests(projectID, sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/merge_requests"
      }
    }
  }
  
  /**
   Get an observable of list of repository commits in a project.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameters parameters: See Query Parameters in the description
   
   **Optional Query Parameters:**
   - **ref_name: String** - The name of a repository branch or tag or if not given the default branch
   - **since: String** - Only commits after or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
   - **until: String** - Only commits before or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
   - **path: String** - The file path
   - **all: Boolean** - Retrieve every commit from the repository
   - **with_stats: Boolean** - Stats about each commit will be added to the response
   
   - Returns: An `Observable` of list of repository `Commit`s in a project
   */
  public func getCommits(projectID: Int, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Commit]> {
    print(projectID)
    let getRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .get, parameters: parameters)
    return object(for: getRequest)
  }
  
  /**
   Get a paginator of list of repository commits in a project.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameters parameters: See Query Parameters in the description
   
   **Optional Query Parameters:**
   - **ref_name: String** - The name of a repository branch or tag or if not given the default branch
   - **since: String** - Only commits after or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
   - **until: String** - Only commits before or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
   - **path: String** - The file path
   - **all: Boolean** - Retrieve every commit from the repository
   - **with_stats: Boolean** - Stats about each commit will be added to the response
   
   - Returns: A Paginator of commits
   */
  public func getCommits(projectID: Int, perPage: Int = RxGitLabAPIClient.defaultPerPage, parameters: QueryParameters? = nil) -> Paginator<Commit> {
    let apiRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .get, parameters: parameters)
    
    let paginator = Paginator<Commit>(communicator: hostCommunicator, apiRequest: apiRequest, perPage: perPage)
    return paginator
  }
  
  /**
   Create a commit
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter newCommit: newCommit
   - Returns: An `Observable` of accepted Commit
   */
  public func createCommit(projectID: Int, newCommit: NewCommit) -> Observable<Commit> {
    let encoder = JSONEncoder()
    guard let newCommitData = try? encoder.encode(newCommit) else {
      return Observable.error(ParsingError.encoding(message: "New Commit could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .post, data: newCommitData)
    return object(for: apiRequest)
  }
  
  /**
   Get a specific commit identified by the commit hash or name of a branch or tag.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit hash or name of a repository branch or tag
   
   **Optional Query Parameters:**
   - **stats: Bool** - Include commit stats. Default is true
   
   - Returns: An `Observable` of `Commit`
   */
  public func getCommit(projectID: Int, sha: String, parameters: QueryParameters? = nil) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.single(projectID: projectID, sha: sha).url, parameters: parameters)
    return object(for: apiRequest)
  }
  
  /**
   Get all references (from branches or tags) a commit is pushed to. The pagination parameters page and per_page can be used to restrict the list of references.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter sha: The commit hash or name of a repository branch or tag
   
   **Optional Query Parameters:**
   - **type: String** - The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`
   
   - Returns: An `Observable` of list of `Reference`
   */
  public func getReferences(projectID: Int, sha: String, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Reference]> {
    let apiRequest = APIRequest(path: Endpoints.references(projectID: projectID, sha: sha).url, parameters: parameters)
    return object(for: apiRequest)
  }
  
  /**
   Get a paginator of references (from branches or tags) a commit is pushed to.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the user
   - Parameter sha: The commit hash or name of a repository branch or tag
   
   **Query Parameters:**
   - Optional:
   - **type: String** - The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`
   
   - Returns: A `Paginator` of `Reference`
   */
  public func getReferences(projectID: Int, sha: String) -> Paginator<Reference> {
    let apiRequest = APIRequest(path: Endpoints.references(projectID: projectID, sha: sha).url)
    let paginator = Paginator<Reference>(communicator: hostCommunicator, apiRequest: apiRequest)
    return paginator
  }
  /**
   Cherry picks a commit to a given branch.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter sha: The commit has
   - Parameter branch: The name of the branch
   - Returns: An `Observable` of `Commit`
   */
  public func cherryPick(projectID: Int, sha: String, branch: String) -> Observable<Commit> {
    let apiRequest =
      APIRequest(path: Endpoints.cherryPick(projectID: projectID, sha: sha).url, method: .post, jsonBody: ["branch": branch])
    return object(for: apiRequest)
  }
  
  /**
   Reverts a commit in a given branch.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter sha: The commit has
   - Parameter branch: The name of the branch
   - Returns: An `Observable` of `Commit`
   */
  public func revert(projectID: Int, sha: String, branch: String) -> Observable<Commit> {
    let apiRequest =
      APIRequest(path: Endpoints.revert(projectID: projectID, sha: sha).url, method: .post, jsonBody: ["branch": branch])
    return object(for: apiRequest)
  }
  
  /**
   Get the diff of a commit in a project.
   
   - Parameter projectID: The ID or URL-encoded path of the project
   - Parameter sha: The commit has
   - Returns: An `Observable` of `Diff`
   */
  public func getDiff(projectID: Int, sha: String) -> Observable<Diff> {
    let apiRequest = APIRequest(path: Endpoints.diff(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  /**
   Get the comments of a commit in a project.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit has
   - Returns: An `Observable` of `Comment`
   */
  public func getComments(projectID: Int, sha: String) -> Observable<[Comment]> {
    let apiRequest = APIRequest(path: Endpoints.comments(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  /**
   Adds a comment to a commit.-
   
   In order to post a comment in a particular line of a particular file, you must specify the full commit SHA, the path, the `line` and `line_type` should be `new`.
   The comment will be added at the end of the last commit if at least one of the cases below is valid:
   - the `sha` is instead a branch or a tag and the `line` or `path` are invalid
   - the `line` number is invalid (does not exist)
   - the `path` is invalid (does not exist)
   - In any of the above cases, the response of `line`, `line_type` and `path` is set to `null`.
   
   - Parameter comment: Comment
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit has
   - Returns: An `Observable` of `Comment`
   */
  public func postComment(comment: Comment, projectID: Int, sha: String) -> Observable<Comment> {
    do {
      let data = try JSONEncoder().encode(comment)
      let apiRequest = APIRequest(path: Endpoints.comments(projectID: projectID, sha: sha).url, method: .post, data: data)
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Get the comments of a commit in a project.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit has
   - Returns: An `Observable` of `Comment`
   */
  public func getStatuses(projectID: Int, sha: String) -> Observable<[CommitStatus]> {
    let apiRequest = APIRequest(path: Endpoints.statusesList(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  /**
   Adds or updates a build status of a commit.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit has
   - Returns: An `Observable` of `Status`
   */
  public func postStatus(status: BuildStatus, projectID: Int, sha: String) -> Observable<CommitStatus> {
    do {
      let apiRequest = APIRequest(path: Endpoints.statuses(projectID: projectID, sha: sha).url, method: .post, data: try JSONEncoder().encode(status))
      return object(for: apiRequest)
    } catch let error {
      return Observable.error(error)
    }
  }
  
  /**
   Get a list of Merge Requests related to the specified commit.
   
   - Parameter projectID: The ID or URL-encoded path of the project owned by the
   - Parameter sha: The commit has
   - Returns: An `Observable` of list of `MergeRequest`s
   */
  public func getMergeRequests(projectID: Int, sha: String) -> Observable<[MergeRequest]> {
    let apiRequest = APIRequest(path: Endpoints.mergeRequests(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
}
