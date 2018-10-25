//
//  CommitEndpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class CommitsEndpointGroup: EndpointGroup {
  
  private enum Endpoints {
    case commits(projectID: String)
    case single(projectID: String, sha: String)
    case references(projectID: String, sha: String)
    case cherryPick(projectID: String, sha: String)
    case diff(projectID: String, sha: String)
    case comments(projectID: String, sha: String)
    case statusesList(projectID: String, sha: String)
    case statuses(projectID: String, sha: String)
    case mergeRequests(projectID: String, sha: String)

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
      case .diff(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/diff"
      case .comments(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/comments"
      case .statusesList(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/statuses"
      case .statuses(let projectID, let sha):
        return "/projects/\(projectID)/statuses/\(sha)"
      case .mergeRequests(let projectID, let sha):
        return "/projects/\(projectID)/repository/commits/\(sha)/merge_requests"
      
      }
    }
  }
  
  ///   Get an observable of list of repository commits in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter parameters: Query Parameters - See description
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **ref_name: String** - The name of a repository branch or tag or if not given the default branch
  ///     - **since: String** - Only commits after or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
  ///     - **until: String** - Only commits before or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
  ///     - **path: String** - The file path
  ///     - **all: Boolean** - Retrieve every commit from the repository
  ///     - **with_stats: Boolean** - Stats about each commit will be added to the response
  ///
  /// - Returns: An observable of list of repository commits in a project
  public func getCommits(projectID: String, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Commit]> {
    let getRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .get, parameters: parameters)
    return object(for: getRequest)
  }
  
  ///   Get a paginator of list of repository commits in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter parameters: Query Parameters - See description
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **ref_name: String** - The name of a repository branch or tag or if not given the default branch
  ///     - **since: String** - Only commits after or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
  ///     - **until: String** - Only commits before or on this date will be returned in ISO 8601 format YYYY-MM-DDTHH:MM:SSZ
  ///     - **path: String** - The file path
  ///     - **all: Boolean** - Retrieve every commit from the repository
  ///     - **with_stats: Boolean** - Stats about each commit will be added to the response
  ///
  /// - Returns: A Paginator
  public func getCommits(projectID: String, parameters: QueryParameters? = nil) -> Paginator<Commit> {
    let apiRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .get, parameters: parameters)
    let paginator = Paginator<Commit>(network: network, hostURL: hostURL, apiRequest: apiRequest, oAuthToken: oAuthToken, privateToken: privateToken)
    return paginator
  }
  
  ///   Create a commit
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter newCommit: newCommit
  /// - Returns: An observable of accepted Commit
  public func createCommit(projectID: String, newCommit: NewCommit) -> Observable<Commit> {
    let encoder = JSONEncoder()
    guard let newCommitData = try? encoder.encode(newCommit) else {
      return Observable.error(ParsingError.encoding(message: "New Commit could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.commits(projectID: projectID).url, method: .post, data: newCommitData)
    return object(for: apiRequest)
  }
  
  ///   Get a specific commit identified by the commit hash or name of a branch or tag.

  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit hash or name of a repository branch or tag
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **stats: Bool** - Include commit stats. Default is true
  ///
  /// - Returns: An observable of Commit
  public func getCommit(projectID: String, sha: String, parameters: QueryParameters? = nil) -> Observable<Commit> {
    let apiRequest = APIRequest(path: Endpoints.single(projectID: projectID, sha: sha).url, parameters: parameters)
    return object(for: apiRequest)
  }
  
  ///   Get all references (from branches or tags) a commit is pushed to. The pagination parameters page and per_page can be used to restrict the list of references.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit hash or name of a repository branch or tag
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **type: String** - The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`
  ///
  /// - Returns: An observable of list of References
  public func getReferences(projectID: String, sha: String, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Reference]> {
    let apiRequest = APIRequest(path: Endpoints.references(projectID: projectID, sha: sha).url, parameters: parameters)
    return object(for: apiRequest)
  }
  
  ///   Get a paginator of references (from branches or tags) a commit is pushed to.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit hash or name of a repository branch or tag
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **type: String** - The scope of commits. Possible values `branch`, `tag`, `all`. Default is `all`
  ///
  /// - Returns: A Paginator of References
  
  public func getReferences(projectID: String, sha: String) -> Paginator<Reference> {
    let apiRequest = APIRequest(path: Endpoints.references(projectID: projectID, sha: sha).url)
    let paginator = Paginator<Reference>(network: network, hostURL: hostURL, apiRequest: apiRequest, oAuthToken: oAuthToken, privateToken: privateToken)
    return paginator
  }
  
  ///   Cherry picks a commit to a given branch.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  ///   - Parameter branch: The name of the branch
  /// - Returns: A Commit
  public func cherryPick(projectID: String, sha: String, branch: String) -> Observable<Commit> {
    let apiRequest =
    APIRequest(path: Endpoints.cherryPick(projectID: projectID, sha: sha).url, method: .post, jsonBody: ["branch" : branch])
    return object(for: apiRequest)
  }
  
  ///   Get the diff of a commit in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A Diff
  public func getDiff(projectID: String, sha: String) -> Observable<Diff> {
    let apiRequest = APIRequest(path: Endpoints.diff(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  ///   Get the comments of a commit in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A Comment
  public func getComments(projectID: String, sha: String) -> Observable<[Comment]> {
    let apiRequest = APIRequest(path: Endpoints.comments(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  ///   Adds a comment to a commit.-
  ///
  ///   In order to post a comment in a particular line of a particular file, you must specify the full commit SHA, the path, the `line` and `line_type` should be `new`.
  ///   The comment will be added at the end of the last commit if at least one of the cases below is valid:
  ///   - the `sha` is instead a branch or a tag and the `line` or `path` are invalid
  ///   - the `line` number is invalid (does not exist)
  ///   - the `path` is invalid (does not exist)
  ///   - In any of the above cases, the response of `line`, `line_type` and `path` is set to `null`.
  ///
  ///   - Parameter comment: Comment
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A Comment
  public func postComment(comment: Comment, projectID: String, sha: String) -> Observable<Comment> {
    do {
      let data = try JSONEncoder().encode(comment)
      let apiRequest = APIRequest(path: Endpoints.comments(projectID: projectID, sha: sha).url, method: .post, data: data)
      return object(for: apiRequest)
    } catch(let error) {
      return Observable.error(error)
    }
  }
  
  ///   Get the comments of a commit in a project.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A Comment
  public func getStatuses(projectID: String, sha: String) -> Observable<[Status]> {
    let apiRequest = APIRequest(path: Endpoints.statuses(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
  
  ///   Adds or updates a build status of a commit.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A Status
  public func postStatus(status: Status, projectID: String, sha: String) -> Observable<Status> {
    do {
    let apiRequest = APIRequest(path: Endpoints.statuses(projectID: projectID, sha: sha).url, method: .post, data: try JSONEncoder().encode(status))
      return object(for: apiRequest)
    } catch (let error) {
      return Observable.error(error)
    }
  }
  
  ///   Get a list of Merge Requests related to the specified commit.
  ///
  ///   - Parameter projectID: The ID or URL-encoded path of the project owned by the
  ///   - Parameter sha: The commit has
  /// - Returns: A list of MergeRequests
  public func getMergeRequests(projectID: String, sha: String) -> Observable<[MergeRequest]> {
    let apiRequest = APIRequest(path: Endpoints.mergeRequests(projectID: projectID, sha: sha).url)
    return object(for: apiRequest)
  }
}
