//
//  ProjectsEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 27/11/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxAtomic
import RxBlocking
import RxTest

class ProjectsEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testGetLanguages() {
    let languages = client.projects.getLanguages(projectID: 4)
    let result = languages
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let languages = element.first!
      print(languages)
      XCTAssertNotNil(languages["Swift"])
      XCTAssertNotNil(languages["Ruby"])
      XCTAssertNotNil(languages["Objective-C"])
      XCTAssertEqual(languages["Swift"]!, 97.47)
      XCTAssertEqual(languages["Ruby"]!, 1.77)
      XCTAssertEqual(languages["Objective-C"]!, 0.76)
      
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetProjects() {
    let result = client.projects.getProjects()
      .loadAll()
      .toBlocking(timeout: 10)
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let projects = elements.first else {
        XCTFail("No projects loaded.")
        return
      }
      XCTAssertEqual(projects.count, 67)
      XCTAssertEqual(projects[0].id, 68)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetProject() {
    let result = client.projects.getProject(projectID: 4)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let project = elements.first else {
        XCTFail("No project received.")
        return
      }
      XCTAssertEqual(project.id, 4)
      
      XCTAssertEqual(project.description, "UITableView and UICollectionView Data Sources for RxSwift (sections, animated updates, editing ...)\r\n")
      XCTAssertEqual(project.name, "RxDataSources")
      XCTAssertEqual(project.visibility, "public")
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetUserProjects() {
    let result = client.projects.getUserProjects(userID: 10)
      .loadAll()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let projects = elements.first else {
        XCTFail("No projects loaded.")
        return
      }
      XCTAssertEqual(projects.count, 60)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }

  func testGetProjectUsers() {
    let result = client.projects.getProjectUsers(projectID: 3)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let users = elements.first else {
         XCTFail("No users loaded.")
        return
      }
      XCTAssertEqual(users.count, 3)
      guard users.count == 3 else {
        XCTFail("Different count of project users: \(users.count)")
        return
      }
      XCTAssertEqual(users[0].username, "root")
      XCTAssertEqual(users[1].username, "freak4pc")
      XCTAssertEqual(users[2].username, "kzaher")

    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testStarAndUnstarProject() {
    _ = client.projects.unstarProject(projectID: 3)
      .toBlocking()
      .materialize()
    
    let starResult = client.projects.starProject(projectID: 3)
      .toBlocking()
      .materialize()
    var starCount = 0
    switch starResult {
    case .completed(elements: let elements):
      guard let project = elements.first else {
        XCTFail("Project not received.")
        return
      }
      starCount = project.starCount
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    
    let unstarResult = client.projects.unstarProject(projectID: 3)
      .toBlocking()
      .materialize()
    
    switch unstarResult {
    case .completed(elements: let elements):
      guard let project = elements.first else {
        XCTFail("Project not received.")
        return
      }
      XCTAssertEqual(project.starCount, starCount - 1)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testArchiveProject() {
    let result = client.projects.archiveProject(projectID: 3)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let project = elements.first else {
        XCTFail("Project not received.")
        return
      }
      XCTAssertEqual(project.id, 3)
      XCTAssertEqual(project.archived, true)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testUnarchiveProject() {
    let result = client.projects.unarchiveProject(projectID: 3)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let project = elements.first else {
        XCTFail("Project not received.")
        return
      }
      XCTAssertEqual(project.id, 3)
      XCTAssertEqual(project.archived, false)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testHookCRUD() {
    let projectID = 50
    var projectHook = ProjectHook(id: nil, url: "https://testhook.io", projectID: nil, pushEvents: nil, pushEventsBranchFilter: nil, issuesEvents: nil, confidentialIssuesEvents: nil, mergeRequestsEvents: nil, tagPushEvents: nil, noteEvents: nil, jobEvents: nil, pipelineEvents: nil, wikiPageEvents: nil, enableSSLVerification: nil, createdAt: nil)
    let createResult = client.projects.postHook(projectID: projectID, hook: projectHook)
      .toBlocking()
      .materialize()
    
    switch createResult {
    case .completed(elements: let elements):
      guard let hook = elements.first else {
        XCTFail("No Hooks received.")
        return
      }
      projectHook = hook
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  
    let getLastResult = client.projects.getHooks(projectID: projectID).loadAll()
      .toBlocking()
      .materialize()
    switch getLastResult {
    case .completed(elements: let elements):
      guard let hooks = elements.first else {
         XCTFail("No Hooks received.")
        return
      }
      let lastHook = hooks.last
      XCTAssertEqual(lastHook?.id, projectHook.id)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    guard projectHook.id != nil else {
      XCTFail("New hook should have an ID.")
      return
    }
    
    let newURL = "https://newurl.io"
    let newProjectHook = ProjectHook(id: projectHook.id!, url: newURL, projectID: nil, pushEvents: nil, pushEventsBranchFilter: nil, issuesEvents: nil, confidentialIssuesEvents: nil, mergeRequestsEvents: nil, tagPushEvents: nil, noteEvents: nil, jobEvents: nil, pipelineEvents: nil, wikiPageEvents: nil, enableSSLVerification: nil, createdAt: nil)

    let putResults = client.projects.putHook(projectID: projectID, hook: newProjectHook)
      .toBlocking()
      .materialize()
    switch putResults {
    case .completed(elements: let elements):
      guard let hook = elements.first else {
        XCTFail("A hook from is expected.")
        return
      }
      XCTAssertEqual(hook.url, newURL)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }

    let deleteResult = client.projects.deleteHook(projectID: projectID, hookID: projectHook.id!)
      .toBlocking()
      .materialize()
    switch deleteResult {
    case .completed(elements: let elements):
      guard let response = elements.first else {
         XCTFail("A response from is expected.")
        return
      }
      XCTAssertEqual(response.statusCode, 204)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
    
    let getResult = client.projects.getHook(projectID: projectID, hookID: projectHook.id!)
      .toBlocking()
      .materialize()
    switch getResult {
    case .completed(elements: _):
     XCTFail("Project Hook should be deleted.")
    case .failed(elements: _, error: let error):
      XCTAssertEqual(error.localizedDescription, "Not Found: {\"message\":\"404 Not found\"}")
    }
  }
  
}

