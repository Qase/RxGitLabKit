//
//  ProjectTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import XCTest
import RxGitLabKit

class ProjectTests: BaseModelTestCase {
  
  func testProjectDecode() {
    do {
      let project = try decoder.decode(Project.self, from: ProjectMocks.projectData)
      XCTAssertEqual(project.id, 4)
      XCTAssertEqual(project.defaultBranch, "master")
      XCTAssertEqual(project.sshURLToRepo, "git@example.com:diaspora/diaspora-client.git")
      XCTAssertEqual(project.httpURLToRepo, "http://example.com/diaspora/diaspora-client.git")
      XCTAssertEqual(project.tagList?.count, 2)
      XCTAssertEqual(project.owner?.id, 3)
      XCTAssertEqual(project.owner?.name, "Diaspora")
      XCTAssertDateEqual(Date.init(from: "2013-09-30T13:46:02.000Z"), project.owner?.createdAt)
      XCTAssertEqual(project.namespace.name, "Diaspora")
      XCTAssertEqual(project.statistics?.commitCount, 37)
      XCTAssertNotNil(project.links)
      
    } catch let error {
      XCTFail("Failed to decode project. Error: \(error.localizedDescription)")
    }
  }
  
  func testLinksDecode() {
    do {
      let links = try decoder.decode(Links.self, from: ProjectMocks.linksData)
      print(links)
      XCTAssertEqual(links.linksSelf, "http://example.com/api/v4/projects")
      XCTAssertEqual(links.issues, "http://example.com/api/v4/projects/1/issues")
      XCTAssertEqual(links.mergeRequests, "http://example.com/api/v4/projects/1/merge_requests")
      XCTAssertEqual(links.repoBranches, "http://example.com/api/v4/projects/1/repository_branches")
      XCTAssertEqual(links.labels, "http://example.com/api/v4/projects/1/labels")
      XCTAssertEqual(links.events, "http://example.com/api/v4/projects/1/events")
      XCTAssertEqual(links.members, "http://example.com/api/v4/projects/1/members")
      
    } catch let error {
      XCTFail("Failed to decode commit. Error: \(error.localizedDescription)")
    }
  }
  
  func testStatisticsDecode() {
    do {
      let statistics = try decoder.decode(ProjectStatistics.self, from: ProjectMocks.statisticsData)
      XCTAssertEqual(statistics.commitCount, 37)
      XCTAssertEqual(statistics.storageSize, 1038090)
      XCTAssertEqual(statistics.repositorySize, 1038090)
      XCTAssertEqual(statistics.lfsObjectsSize, 0)
      XCTAssertEqual(statistics.jobArtifactsSize, 0)
    } catch let error {
      XCTFail("Failed to decode commit. Error: \(error.localizedDescription)")
    }
  }
  
  func testNamespaceDecode() {
    do {
      let namespace = try decoder.decode(Namespace.self, from: ProjectMocks.namespaceData)
      XCTAssertEqual(namespace.id, 3)
      XCTAssertEqual(namespace.name, "Diaspora")
      XCTAssertEqual(namespace.path, "diaspora")
      XCTAssertEqual(namespace.kind, "group")
      XCTAssertEqual(namespace.fullPath, "diaspora")
    } catch let error {
      XCTFail("Failed to decode commit. Error: \(error.localizedDescription)")
    }
  }
  
  func testUserDecode() {
    do {
      let user = try decoder.decode(User.self, from: ProjectMocks.userData)
      XCTAssertEqual(user.id, 3)
      XCTAssertEqual(user.name, "Diaspora")
    } catch let error {
      XCTFail("Failed to decode commit. Error: \(error.localizedDescription)")
    }
  }
  
  func testHookDecode() {
    do {
      let object = try decoder.decode(ProjectHook.self, from: ProjectMocks.hookData)
      XCTAssertEqual(object.id, 1)
      XCTAssertEqual(object.url, "http://example.com/hook")
      XCTAssertEqual(object.projectID, 3)
      XCTAssertEqual(object.pushEvents, true)
      XCTAssertEqual(object.pushEventsBranchFilter, "")
      XCTAssertEqual(object.issuesEvents, true)
      XCTAssertEqual(object.confidentialIssuesEvents, true)
      XCTAssertEqual(object.mergeRequestsEvents, true)
      XCTAssertEqual(object.tagPushEvents, true)
      XCTAssertEqual(object.noteEvents, true)
      XCTAssertEqual(object.jobEvents, true)
      XCTAssertEqual(object.pipelineEvents, true)
      XCTAssertEqual(object.wikiPageEvents, true)
      XCTAssertEqual(object.enableSSLVerification, true)
      let timeZone = TimeZone(secondsFromGMT: 0)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 10, day: 12, hour: 17, minute: 4, second: 47)
      let date = calendar.date(from: components)!
      XCTAssertEqual(object.createdAt, date)
    } catch let error {
      XCTFail("Failed to decode commit. Error: \(error.localizedDescription)")
    }
  }
  
  func testLanguagesDecode() {
    do {
      let dict = try JSONSerialization.jsonObject(with: ProjectMocks.languagesData, options: []) as! [String: Double]
      print(dict)
    } catch let error {
      XCTFail("Failed to decode langugages. Error: \(error.localizedDescription)")
    }
  }
  
  func testShareGroupSerialization() {
    var jsonBody: [String: Any] = [
      "id": 1,
      "group_id": 4,
      "group_access": 20
    ]
    let dateString = DateFormatter.iso8601full.string(from: Date())
    jsonBody["expires_at"] = dateString
    do {
    let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: .sortedKeys)
      XCTAssertEqual(String(data: jsonData, encoding:.utf8)!, "{\"expires_at\":\"\(dateString)\",\"group_access\":20,\"group_id\":4,\"id\":1}")
    } catch let error {
      XCTFail("Failed to decode langugages. Error: \(error.localizedDescription)")
    }
    
  }
}
