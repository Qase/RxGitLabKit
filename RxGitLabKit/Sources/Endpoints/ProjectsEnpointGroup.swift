//
//  ProjectsEnpointGroup.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 23/08/2018.
//

import Foundation
import RxSwift

/**
 This EndpointGroup communicates with Projects API (https://docs.gitlab.com/ce/api/projects.html)
 # Projects API
 ## Project visibility level
 Project in GitLab can be either private, internal or public. This is determined by the `visibility` field in the project.
 
 Values for the project visibility level are:
 - `private`: Project access must be granted explicitly for each user.
 - `internal`: The project can be cloned by any logged in user.
 - `public`: The project can be cloned without any authentication.
 
 ## Project merge method
 There are currently three options for merge_method to choose from:
 - `merge`: A merge commit is created for every merge, and merging is allowed as long as there are no conflicts.
 - `rebase_merge`: A merge commit is created for every merge, but merging is only allowed if fast-forward merge is possible. This way you could make sure that if this merge request would build, after merging to target branch it would also build.
 - `ff`: No merge commits are created and all merges are fast-forwarded, which means that merging is only allowed if the branch could be fast-forwarded.
 */
public class ProjectsEnpointGroup: EndpointGroup {

  public enum Endpoints {
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
    case shareGroup(projectID: String, groupID: Int)
    case hook(projectID: String, hookID: Int)
    case hooks(projectID: String)
    case forkRelationship(projectID: String, forkedFromID: Int)
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

  ///   List all projects
  ///   Get a list of all visible projects across GitLab for the authenticated user. When accessed without authentication, only public projects with “simple” fields are returned.
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///     - **archived: Boolean** -   Limit by archived status
  ///     - **visibility: String** -   Limit by visibility public, internal, or private
  ///     - **order_by: String** -   Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields. Default is created_at
  ///     - **sort: String** -   Return projects sorted in asc or desc order. Default is desc
  ///     - **search: String** -   Return list of projects matching the search criteria
  ///     - **simple  boolean  Return** -  only limited fields for each project. This is a no-op without authentication as then only simple fields are returned:
  ///     - **owned: Boolean** -   Limit by projects explicitly owned by the current user
  ///     - **membership: Boolean** -   Limit by projects that the current user is a member of
  ///     - **starred: Boolean** -   Limit by projects starred by the current user
  ///     - **statistics: Boolean** -   Include project statistics
  ///     - **with_custom_attributes: Boolean** -   Include custom attributes in response (admins only)
  ///     - **with_issues_enabled: Boolean** -   Limit by enabled issues feature
  ///     - **with_merge_requests_enabled: Boolean** -   Limit by enabled merge requests feature
  ///     - **wiki_checksum_failed: Boolean** -   Limit projects where the wiki checksum calculation has failed (Introduced in GitLab Premium 11.2)
  ///     - **repository_checksum_failed: Boolean** -   Limit projects where the repository checksum calculation has failed (Introduced in GitLab Premium 11.2)
  ///     - **min_access_level: Integer** -   Limit by current user minimal access level
  ///
  /// - Returns: An observable of list of projects in a project
  public func getProject(projectID: String, parameters: QueryParameters? = nil) -> Observable<Project> {
    let request = APIRequest(path: Endpoints.project(projectID: projectID).url, parameters: parameters)
    return object(for: request)
  }

  public func getProjects(parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Project]> {
    let request = APIRequest(path: Endpoints.projects.url, parameters: parameters)
    return object(for: request)
  }

  /// Get single project
  ///
  /// Get a specific project. This endpoint can be accessed without authentication if the project is publicly accessible.
  /// - Parameter projectID: ID of the project
  /// - Returns: An observable of `Project`
  public func getProject(projectID: String) -> Observable<Project> {
    let apiRequest = APIRequest(path: Endpoints.project(projectID: projectID).url)
    return object(for: apiRequest)
  }

  /// Get project users
  ///
  /// Get the users list of a project. The pagination parameters page and per_page can be used to restrict the list of references.
  /// - Parameters:
  ///   - userID: ID of the user
  ///   - parameters: Query Parameters - See description
  ///   - page: The page number
  ///   - perPage: Maximum item count per page
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///   - **user_id: String** - The ID or username of the user
  ///   - **archived: Boolean** - Limit by archived status
  ///   - **visibility: String** - Limit by visibility public, internal, or private
  ///   - **order_by: String** - Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields. Default is created_at
  ///   - **sort: String** - Return projects sorted in asc or desc order. Default is desc
  ///   - **search: String** - Return list of projects matching the search criteria
  ///   - **simple: Boolean** - Return only limited fields for each project. This is a no-op without authentication as then only simple fields are returned.
  ///   - **owned: Boolean** - Limit by projects explicitly owned by the current user
  ///   - **membership: Boolean** - Limit by projects that the current user is a member of
  ///   - **starred: Boolean** - Limit by projects starred by the current user
  ///   - **statistics: Boolean** - Include project statistics
  ///   - **with_custom_attributes: Boolean** - Include custom attributes in response (admins only)
  ///   - **with_issues_enabled: Boolean** - Limit by enabled issues feature
  ///   - **with_merge_requests_enabled: Boolean** - Limit by enabled merge requests feature
  ///   - **min_access_level: Integer** - Limit by current user minimal access level
  /// - Returns: An observable of list of Project
  public func getUserProjects(userID: String, parameters: QueryParameters? = nil, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> Observable<[Project]> {
    let request = APIRequest(path: Endpoints.userProjects(userID: userID).url, parameters: parameters)
    return object(for: request)
  }

  /// Get project users
  ///
  /// Get the paginator of users list of a project.
  /// - Parameters:
  ///   - userID: ID of the user
  ///   - page: The page number
  ///   - perPage: Maximum item count per page
  ///
  /// **Query Parameters:**
  /// - Optional:
  ///   - **user_id: String** - The ID or username of the user
  ///   - **archived: Boolean** - Limit by archived status
  ///   - **visibility: String** - Limit by visibility public, internal, or private
  ///   - **order_by: String** - Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields. Default is created_at
  ///   - **sort: String** - Return projects sorted in asc or desc order. Default is desc
  ///   - **search: String** - Return list of projects matching the search criteria
  ///   - **simple: Boolean** - Return only limited fields for each project. This is a no-op without authentication as then only simple fields are returned.
  ///   - **owned: Boolean** - Limit by projects explicitly owned by the current user
  ///   - **membership: Boolean** - Limit by projects that the current user is a member of
  ///   - **starred: Boolean** - Limit by projects starred by the current user
  ///   - **statistics: Boolean** - Include project statistics
  ///   - **with_custom_attributes: Boolean** - Include custom attributes in response (admins only)
  ///   - **with_issues_enabled: Boolean** - Limit by enabled issues feature
  ///   - **with_merge_requests_enabled: Boolean** - Limit by enabled merge requests feature
  ///   - **min_access_level: Integer** - Limit by current user minimal access level
  /// - Returns: An observable of list of Project
  public func getUserProjects(userID: String, parameters: QueryParameters? = nil) -> ArrayPaginator<Project> {
    let apiRequest = APIRequest(path: Endpoints.userProjects(userID: userID).url, parameters: parameters)
    let paginator = ArrayPaginator<Project>(communicator: hostCommunicator, apiRequest: apiRequest)
    return paginator
  }

  /// Get project users
  ///
  /// Get the users list of a project.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of list of Users
  public func getProjectUsers(projectID: String) -> Observable<[User]> {
    let request = APIRequest(path: Endpoints.projectUsers(projectID: projectID).url)
    return object(for: request)
  }

  /// Create project
  ///
  /// Creates a new project owned by the authenticated user.
  /// - Parameter project: A Project to be created
  /// - Returns: A posted Project
  public func postProject(project: Project) -> Observable<Project> {
    let encoder = JSONEncoder()
    guard let newProjectData = try? encoder.encode(project) else {
      return Observable.error(ParsingError.encoding(message: "New Project could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.projects.url, method: .post, data: newProjectData)
    return object(for: apiRequest)
  }

  /// Remove project
  ///
  /// Removes a project including all associated resources (issues, merge requests etc.)
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of server HTTPURLResponse
  public func deleteProject(projectID: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.project(projectID: projectID).url, method: .delete)
    return httpURLResponse(for: apiRequest)
  }

  /// Create project for user
  ///
  /// Creates a new project owned by the specified user. Available **only for admins**.
  /// - Parameters:
  ///   - project: A Project Object
  ///   - userID: The user ID of the project owner
  /// - Returns: An observable of the posted Project
  public func postProjectForUser(project: Project, userID: String) -> Observable<Project> {
    let encoder = JSONEncoder()
    guard let newProjectData = try? encoder.encode(project) else {
      return Observable.error(ParsingError.encoding(message: "New Project could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.createUserProject(userID: userID).url, method: .post, data: newProjectData)
    return object(for: apiRequest)
  }

  /// Edit project
  ///
  /// Updates an existing project.
  /// - Parameter project: A Project to be updated
  /// - Returns: An observable of Project
  public func putProject(project: Project) -> Observable<Project> {
    let encoder = JSONEncoder()
    guard let projectID = project.id else {
      return Observable.error(ParsingError.encoding(message: "No project ID found."))
    }
    guard let projectData = try? encoder.encode(project) else {
      return Observable.error(ParsingError.encoding(message: "Project could not be encoded"))
    }
    let apiRequest = APIRequest(path: Endpoints.project(projectID: "\(projectID)").url, method: .post, data: projectData)
    return object(for: apiRequest)
  }

  /// Fork project
  ///
  /// Forks a project into the user namespace of the authenticated user or the one provided.
  /// The forking operation for a project is asynchronous and is completed in a background job. The request will return immediately. To determine whether the fork of the project has completed, query the `import_status` for the new project.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - namespace: The ID or path of the namespace that the project will be forked to
  /// - Returns: An observable of server HTTPURLResponse
  public func forkProject(projectID: String, namespace: String) -> Observable<HTTPURLResponse> {
    let params = ["namespace" : namespace]
    let apiRequest = APIRequest(path: Endpoints.fork(projectID: projectID).url, method: .post, parameters: params)
    return httpURLResponse(for: apiRequest)
  }

  /// List Forks of a project
  ///
  /// List the projects accessible to the calling user that have an established, forked relationship with the specified project
  /// - Parameters:
  ///   - projectID: projectID descriptionThe ID or URL-encoded path of the project
  ///   - parameters: Query Parameters - See description
  /// **Query Parameters:**
  /// - Optional:
  ///   - **archived: Boolean** - Limit by archived status
  ///   - **visibility: String** - Limit by visibility public, internal, or private
  ///   - **order_by: String** - Return projects ordered by id, name, path, created_at, updated_at, or last_activity_at fields. Default is created_at
  ///   - **sort: String** - Return projects sorted in asc or desc order. Default is desc
  ///   - **search: String** - Return list of projects matching the search criteria
  ///   - **simple: Boolean** - Return only limited fields for each project. This is a no-op without authentication as then only simple fields are returned.
  ///   - **owned: Boolean** - Limit by projects explicitly owned by the current user
  ///   - **membership: Boolean** - Limit by projects that the current user is a member of
  ///   - **starred: Boolean** - Limit by projects starred by the current user
  ///   - **statistics: Boolean** - Include project statistics
  ///   - **with_custom_attributes: Boolean** - Include custom attributes in response (admins only)
  ///   - **with_issues_enabled: Boolean** - Limit by enabled issues feature
  ///   - **with_merge_requests_enabled: Boolean** - Limit by enabled merge requests feature
  ///   - **min_access_level: Integer** - Limit by current user minimal access level
  /// - Returns: An observable of list of projects
  public func getProjectForks(projectID: String, parameters: QueryParameters? = nil ) -> Observable<[Project]> {
    let request = APIRequest(path: Endpoints.fork(projectID: projectID).url, parameters: parameters)
    return object(for: request)
  }

  /// Star a project
  ///
  /// Stars a given project. Returns status code `304` if the project is already starred.
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of a starred project
  public func starProject(projectID: String) -> Observable<Project> {
    let apiRequest = APIRequest(path: Endpoints.star(projectID: projectID).url, method: .post)
    return object(for: apiRequest)
  }

  /// Unstar a project
  ///
  /// Unstars a given project. Returns status code `304` if the project is not starred.
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of a starred project
  public func unstarProject(projectID: String) -> Observable<Project> {
    let apiRequest = APIRequest(path: Endpoints.unstar(projectID: projectID).url, method: .post)
    return object(for: apiRequest)
  }

  /// Languages
  ///
  /// Get languages used in a project with percentage value.
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of a dictionary of languages
  public func getLanguages(projectID: String ) -> Observable<[String: Double]> {
    let apiRequest = APIRequest(path: Endpoints.unstar(projectID: projectID).url, method: .post)
    return data(for: apiRequest).flatMap({ (data) -> Observable<[String: Double]> in
      return Observable<[String: Double]>.create { observer -> Disposable in
        do {
          let dict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Double]
          observer.onNext(dict)
          observer.onCompleted()
        } catch let error {
          observer.onError(error)
        }
        return Disposables.create()
      }
    })
  }

  /// Archive a project
  ///
  /// Archives the project if the user is either admin or the project owner of this project. This action is idempotent, thus archiving an already archived project will not change the project.
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of a project
  public func archiveProject(projectID: String) -> Observable<Project> {
    let apiRequest = APIRequest(path: Endpoints.archive(projectID: projectID).url, method: .post)
    return object(for: apiRequest)
  }

  /// Unarchive a project
  ///
  /// Unarchives the project if the user is either admin or the project owner of this project. This action is idempotent, thus unarchiving a non-archived project will not change the project.
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of a project
  public func unarchiveProject(projectID: String) -> Observable<Project> {
    let apiRequest = APIRequest(path: Endpoints.unarchive(projectID: projectID).url, method: .post)
    return object(for: apiRequest)
  }

  /// Share project with group
  ///
  /// Allow to share project with group.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - groupID: The ID of the group to share with
  ///   - groupAccess: The permissions level to grant the group
  ///   - expiresAt: Share expiration date
  /// - Returns: An observable of server HTTPURLResponse
  public func shareProjectWithGroup(projectID: String, groupID: Int, groupAccess: Int, expiresAt: Date? = nil) -> Observable<HTTPURLResponse> {

    var jsonBody: [String: Any] = [
      "id": projectID,
      "group_id": groupID,
      "group_access": groupAccess
      ]

    if let date = expiresAt {
      jsonBody["expires_at"] = date.asISO8601String
    }

    let apiRequest = APIRequest(path: Endpoints.star(projectID: projectID).url, method: .post, jsonBody: jsonBody)
    return response(for: apiRequest)
      .map { ( response, _) -> HTTPURLResponse in
        return response
      }
  }

  /// Delete a shared project link within a group
  ///
  /// Unshare the project from the group. Returns `204` and no content on success.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - groupID: The ID of the group
  /// - Returns: An observable of server HTTPURLResponse
  public func deleteSharedProjectWithinGroup(projectID: String, groupID: Int) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.shareGroup(projectID: projectID, groupID: groupID).url, method: .delete)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }

  /// List project hooks
  ///
  /// Get a list of project hooks.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - page: The page number
  ///   - perPage: Maximum item count per page
  /// - Returns: A paginator of Hook
  public func getHooks(projectID: String, page: Int = 1, perPage: Int = RxGitLabAPIClient.defaultPerPage) -> ArrayPaginator<ProjectHook> {
    let apiRequest = APIRequest(path: Endpoints.hooks(projectID: projectID).url)
    let paginator = ArrayPaginator<ProjectHook>(communicator: hostCommunicator, apiRequest: apiRequest)
    return paginator
  }

  /// Get project hook
  ///
  /// Get a specific hook for a project.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - hookID: The ID of a project hook
  /// - Returns: An observable of a ProjectHook
  public func getHook(projectID: String, hookID: Int) -> Observable<ProjectHook> {
    let apiRequest = APIRequest(path: Endpoints.hook(projectID: projectID, hookID: hookID).url)
    return object(for: apiRequest)
  }

  /// Add project hook
  ///
  /// Adds a hook to a specified project.
  /// - Parameters:
  ///   - projectID: The ID of a project hook
  ///   - hook: A Hook to be created
  /// - Returns: An observable of server HTTPURLResponse
  public func postHook(projectID: String, hook: ProjectHook) -> Observable<HTTPURLResponse> {
    do {
      let data = try JSONEncoder().encode(hook)
      let apiRequest = APIRequest(path: Endpoints.hooks(projectID: projectID).url, method: .post, data: data)
      return response(for: apiRequest)
        .map { (response, _) -> HTTPURLResponse in return response }
    } catch let error {
      return Observable.error(error)
    }
  }

  /// Edit project hook
  ///
  /// Edits a hook for a specified project.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - hook: A hook to be updated
  /// - Returns: An observable of server HTTPURLResponse
  public func putHook(projectID: String, hook: ProjectHook) -> Observable<HTTPURLResponse> {
    do {
      let data = try JSONEncoder().encode(hook)
      let apiRequest = APIRequest(path: Endpoints.hook(projectID: projectID, hookID: hook.id!).url, method: .put, data: data)
      return response(for: apiRequest)
        .map { (response, _) -> HTTPURLResponse in return response }
    } catch let error {
      return Observable.error(error)
    }
  }

  /// Delete project hook
  ///
  /// Removes a hook from a project. This is an idempotent method and can be called multiple times. Either the hook is available or not.
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project

  ///   - hookID: The ID of the project hook

  /// - Returns: An observable of server HTTPURLResponse
  public func deleteHook(projectID: String, hookID: Int) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.hook(projectID: projectID, hookID: hookID).url, method: .delete)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }

  /// Create a forked from/to relation between existing projects
  ///
  /// - Parameters:
  ///   - projectID: The ID or URL-encoded path of the project
  ///   - forkedFromID: The ID of the project that was forked from
  /// - Returns: An observable of server HTTPURLResponse
  public func postForkRelation(projectID: String, forkedFromID: Int) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.forkRelationship(projectID: projectID, forkedFromID: forkedFromID).url, method: .post)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }

  /// Delete an existing forked from relationship
  ///
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of server HTTPURLResponse
  public func deleteForkRelation(projectID: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.fork(projectID: projectID).url, method: .delete)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }

  /// Start the Housekeeping task for a Project
  ///
  /// - Parameter projectID: The ID or URL-encoded path of the project
  /// - Returns: An observable of server HTTPURLResponse
  public func postHousekeeping(projectID: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.housekeeping(projectID: projectID).url, method: .post)
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }

  /// Transfer a project to a new namespace
  ///
  /// - Parameters:
  ///   - projectID: The ID of the project
  ///   - namespace: The ID or path of the namespace to transfer to project to
  /// - Returns: An observable of server HTTPURLResponse
  public func putTransfer(projectID: String, namespace: String) -> Observable<HTTPURLResponse> {
    let apiRequest = APIRequest(path: Endpoints.transfer(projectID: projectID).url, method: .put, jsonBody: ["namespace" : namespace])
    return response(for: apiRequest)
      .map { (response, _) -> HTTPURLResponse in return response }
  }
}
