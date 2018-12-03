//
//  CommitsEndpointGroupIntegrationTests.swift
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
import RxCocoa

class CommitsEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  let calendar = Calendar(identifier: .gregorian)

  override func tearDown() {
  }
  
  func testGetCommits() {
    let paginator = client.commits.getCommits(projectID: 7)
    let result = paginator[1]
      .filter {!$0.isEmpty}
      .toBlocking(timeout: 1)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      
      XCTAssertEqual(element.count, 1)
      let commits = element.first!
      XCTAssertEqual(commits.count, 20)
      let firstCommit = commits.first!
      XCTAssertEqual(firstCommit.id, "7531fd3de94ff4291244a272b8763eb096c7f6f4")
      XCTAssertEqual(firstCommit.shortId, "7531fd3d")
      XCTAssertEqual(firstCommit.title, "Merge pull request #20779 from rjmccall/lazy-property-is-mutating")
      XCTAssertNotNil(firstCommit.authoredDate)
      XCTAssertNotNil(firstCommit.committedDate)
      XCTAssertNotNil(firstCommit.createdAt)
      XCTAssertEqual(firstCommit.parentIds?.count, 2)
      
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetCommit() {
    let commit = client.commits.getCommit(projectID: 7, sha: "12de97c73fd79017f281b97b1ecec041ce7e9416")
    let result = commit
      .toBlocking(timeout: 1)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let commit = element.first!
      XCTAssertEqual(commit.id, "12de97c73fd79017f281b97b1ecec041ce7e9416")
      XCTAssertEqual(commit.shortId, "12de97c7")
      XCTAssertEqual(commit.title, "Runtime: Some const correctness")
      XCTAssertEqual(commit.authorName, "Slava Pestov")
      XCTAssertEqual(commit.authorEmail, "spestov@apple.com")
      XCTAssertEqual(commit.committerName, "Slava Pestov")
      XCTAssertEqual(commit.committerEmail, "spestov@apple.com")
      XCTAssertEqual(commit.message, "Runtime: Some const correctness\n")
      XCTAssertNotNil(commit.parentIds)
      XCTAssertEqual(commit.parentIds!.count, 1)
      XCTAssertEqual(commit.parentIds!.first!, "20f29c68d96d5b84749fa9b507ff665ba27cd00d")
      XCTAssertNil(commit.lastPipeline)
      XCTAssertNil(commit.status)
      XCTAssertNotNil(commit.stats)
      let stats = commit.stats!
      XCTAssertEqual(stats.additions, 12)
      XCTAssertEqual(stats.deletions, 12)
      XCTAssertEqual(stats.total, 24)
      
      let timeZone = TimeZone(secondsFromGMT: 0)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 27, hour: 2, minute: 22, second: 48)
      let date = calendar.date(from: components)!
      
      let authoredComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 26, hour: 22, minute: 33, second: 54)
      let authoredDate = calendar.date(from: authoredComponents)!
      XCTAssertEqual(commit.createdAt, date)
      XCTAssertEqual(commit.authoredDate, authoredDate)
      XCTAssertEqual(commit.committedDate, date)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
//  func testCreateCommit() {
//    mockSession.nextData = CommitsMocks.newCommitResponseData
//    let projectID = CommitsMocks.mockProjectID
//    let commit = client.commits.createCommit(projectID: projectID, newCommit: CommitsMocks.newCommitMock)
//    let result = commit
//      .toBlocking(timeout: 1)
//      .materialize()
//
//    switch result {
//    case .completed(elements: let element):
//      XCTAssertEqual(element.count, 1)
//      let commit = element.first!
//
//      XCTAssertNotNil(mockSession.lastURL)
//      XCTAssertEqual(URLComponents(url: mockSession.lastURL!, resolvingAgainstBaseURL: false)!.path, "\(RxGitLabAPIClient.apiVersionURLString)\(CommitsEndpointGroup.Endpoints.commits(projectID: CommitsMocks.mockProjectID).url)")
//      XCTAssertNotNil(mockSession.lastRequest)
//      XCTAssertNotNil(mockSession.lastRequest!.httpBody)
//
//      let bodyData = mockSession.lastRequest!.httpBody!
//      XCTAssertEqual(mockSession.lastRequest?.httpMethod, HTTPMethod.post.rawValue)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"])
//      XCTAssertEqual(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"], "application/json")
//      XCTAssertEqual(commit.id, "ed899a2f4b50b4370feeea94676502b42383c746")
//      XCTAssertEqual(commit.shortId, "ed899a2f4b5")
//      XCTAssertEqual(commit.title, "some commit message")
//
//      guard let dict = try? JSONSerialization.jsonObject(with: bodyData, options: .mutableContainers) as! [String: Any] else {
//        XCTFail(HTTPError.noData.localizedDescription)
//        return
//      }
//
//      XCTAssertNotNil(dict["actions"])
//      XCTAssertNotNil(dict["branch"])
//      XCTAssertNotNil(dict["commit_message"])
//      XCTAssertEqual(dict["branch"]! as! String, "master")
//      XCTAssertEqual(dict["commit_message"]! as! String, "some commit message")
//      XCTAssertEqual((dict["actions"]! as! [Any]).count, 5)
//    case .failed(elements: _, error: let error):
//      XCTFail(error.localizedDescription)
//    }
//  }
  
  func testGetReferences() {
    let result = client.commits.getReferences(projectID: 50, sha: "86081d5582d440a5bf39931c15c08d940a783f6c", parameters: nil)
      .toBlocking(timeout: 20)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let references = element.first!
      XCTAssertEqual(references.count, 2)
      XCTAssertEqual(references[0].type, "branch")
      XCTAssertEqual(references[0].name, "master")
      XCTAssertEqual(references[1].type, "branch")
      XCTAssertEqual(references[1].name, "master-next")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
//  func testCherryPick() {
//    mockSession.nextData = CommitsMocks.cherryPickResponseData
//    let projectID = 8908
//    let sha = "ouqertjnsmvnjhrejk"
//    let branch = "master"
//    let commit = client.commits.cherryPick(projectID: projectID, sha: sha, branch: branch)
//
//    let result = commit
//      .toBlocking(timeout: 1)
//      .materialize()
//
//    switch result {
//    case .completed(elements: let element):
//      XCTAssertEqual(element.count, 1)
//      let commit = element.first!
//
//      XCTAssertNotNil(mockSession.lastURL)
//      XCTAssertEqual(URLComponents(url: mockSession.lastURL!, resolvingAgainstBaseURL: false)!.path, "\(RxGitLabAPIClient.apiVersionURLString)\(CommitsEndpointGroup.Endpoints.cherryPick(projectID: projectID, sha: sha).url)")
//      XCTAssertNotNil(mockSession.lastRequest)
//      XCTAssertNotNil(mockSession.lastRequest!.httpBody)
//      XCTAssertEqual(String(data: mockSession.lastRequest!.httpBody!, encoding: .utf8), "{\"branch\":\"master\"}")
//      XCTAssertEqual(mockSession.lastRequest?.httpMethod, HTTPMethod.post.rawValue)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"])
//
//      XCTAssertEqual(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"], "application/json")
//
//      XCTAssertEqual(commit.id, "8b090c1b79a14f2bd9e8a738f717824ff53aebad")
//      XCTAssertEqual(commit.shortId, "8b090c1b")
//
//    case .failed(elements: _, error: let error):
//      XCTFail(error.localizedDescription)
//    }
//  }
  
  func testGetComments() {
    let result = client.commits.getComments(projectID: 7, sha: "12de97c73fd79017f281b97b1ecec041ce7e9416")
      .toBlocking(timeout: 1)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let comments = element.first!
      XCTAssertEqual(comments.count, 2)
      let comment = comments.first!
      XCTAssertEqual(comment.note, "Mock comment")
      XCTAssertNotNil(comment.author)
      let author = comment.author!
      XCTAssertEqual(author.id, 1)
      XCTAssertEqual(author.username, "root")
      XCTAssertEqual(author.name, "Administrator")
      
      let comment2 = comments[1]
      XCTAssertEqual(comment2.note, "Mock comment 2")
      XCTAssertNotNil(comment2.author)
      let author2 = comment2.author!
      XCTAssertEqual(author2.id, 1)
      XCTAssertEqual(author2.username, "root")
      XCTAssertEqual(author2.name, "Administrator")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
//  func testPostComment() {
//    mockSession.nextData = CommitsMocks.commentResponseData
//    let projectID = CommitsMocks.mockProjectID
//    let sha = "18f3e63d05582537db6d183d9d557be09e1f90c8"
//    let note = "Nice picture man!"
//    let lineType = "new"
//    let path = "dudeism.md"
//    let comment: Comment = Comment(note: note, lineType: lineType, line: 1, path: path)
//
//    let result = client.commits.postComment(comment: comment, projectID: projectID, sha: sha)
//      .toBlocking(timeout: 1)
//      .materialize()
//
//    switch result {
//    case .completed(elements: let element):
//      XCTAssertEqual(element.count, 1)
//      let comment = element.first!
//      XCTAssertNotNil(mockSession.lastURL)
//      XCTAssertEqual(URLComponents(url: mockSession.lastURL!, resolvingAgainstBaseURL: false)!.path, "\(RxGitLabAPIClient.apiVersionURLString)\(CommitsEndpointGroup.Endpoints.comments(projectID: projectID, sha: sha).url)")
//      XCTAssertNotNil(mockSession.lastRequest)
//      XCTAssertNotNil(mockSession.lastRequest!.httpBody)
//      XCTAssertEqual(mockSession.lastRequest?.httpMethod, HTTPMethod.post.rawValue)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"])
//      XCTAssertEqual(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"], "application/json")
//
//      XCTAssertEqual(comment.note, note)
//      XCTAssertNotNil(comment.author)
//      let author = comment.author!
//      XCTAssertEqual(author.id, 28)
//      XCTAssertEqual(author.username, "thedude")
//      XCTAssertEqual(author.name, "Jeff Lebowski")
//      XCTAssertEqual(comment.lineType, lineType)
//      XCTAssertEqual(comment.path, path)
//
//      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2016, month: 1, day: 19, hour: 9, minute: 44, second: 55))!
//      XCTAssertEqual(comment.createdAt, date)
//
//    case .failed(elements: _, error: let error):
//      XCTFail(error.localizedDescription)
//    }
//  }
  
  func testGetStatuses() {
    let result = client.commits.getStatuses(projectID: 50, sha: "86081d5582d440a5bf39931c15c08d940a783f6c")
      .toBlocking(timeout: 10)
      .materialize()
    
    switch result {
    case .completed(elements: let element):

      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 11, day: 27, hour: 10, minute: 26, second: 32))!

      XCTAssertEqual(element.count, 1)
      let statuses = element.first!
      XCTAssertEqual(statuses.count, 3)
      let firstStatus = statuses[0]
      XCTAssertEqual(firstStatus.name, "test")

      XCTAssertEqual(firstStatus.status, "created")
      XCTAssertNotNil(firstStatus.createdAt)
      XCTAssertEqual(Int(firstStatus.createdAt!.timeIntervalSinceReferenceDate), Int(date.timeIntervalSinceReferenceDate))
      XCTAssertEqual(firstStatus.allowFailure, false)
      XCTAssertEqual(firstStatus.id, 35)
      XCTAssertEqual(firstStatus.sha, "86081d5582d440a5bf39931c15c08d940a783f6c")
      XCTAssertEqual(firstStatus.ref, "master")
      XCTAssertNil(firstStatus.startedAt)
      XCTAssertNil(firstStatus.description)
      XCTAssertNil(firstStatus.finishedAt)
      XCTAssertNotNil(firstStatus.author)
      let author = firstStatus.author!
      XCTAssertEqual(author.id, 1)
      XCTAssertEqual(author.name, "Administrator")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testPostStatus() {
    let projectID = 50
    let sha = "18f3e63d05582537db6d183d9d557be09e1f90c8"

    let status = CommitStatus(status: "success")
    let result = client.commits.postStatus(status: status, projectID: projectID, sha: sha)
      .toBlocking(timeout: 1)
      .materialize()

    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let status = element.first!
//      XCTAssertNotNil(mockSession.lastURL)
//      XCTAssertEqual(URLComponents(url: mockSession.lastURL!, resolvingAgainstBaseURL: false)!.path, "\(RxGitLabAPIClient.apiVersionURLString)\(CommitsEndpointGroup.Endpoints.statuses(projectID: CommitsMocks.mockProjectID, sha: sha).url)")
//      XCTAssertNotNil(mockSession.lastRequest)
//      XCTAssertNotNil(mockSession.lastRequest!.httpBody)
//      XCTAssertEqual(mockSession.lastRequest?.httpMethod, HTTPMethod.post.rawValue)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields)
//      XCTAssertNotNil(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"])
//      XCTAssertEqual(mockSession.lastRequest!.allHTTPHeaderFields!["Content-Type"], "application/json")

      XCTAssertEqual(status.status, "success")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testGetMergeRequests() {
    let result = client.commits.getMergeRequests(projectID: 7, sha: "f4afcfe641651408a8612c1fe704be6ef0427caf")
      .toBlocking(timeout: 1)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let mergeRequest = element.first!.first!
      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 11, day: 28, hour: 13, minute: 20, second: 14))!
      
      XCTAssertEqual(mergeRequest.id, 1)
      XCTAssertEqual(mergeRequest.iid, 1)
      XCTAssertEqual(mergeRequest.projectID, 7)
      XCTAssertEqual(mergeRequest.title, "5.0 dont hardcode numbers in objc block sil")
      XCTAssertEqual(mergeRequest.description, "")
      XCTAssertEqual(mergeRequest.state, "opened")
      XCTAssertDateEqual(mergeRequest.createdAt, date)
      XCTAssertDateEqual(mergeRequest.updatedAt, date)
      XCTAssertEqual(mergeRequest.targetBranch, "master")
      XCTAssertEqual(mergeRequest.sourceProjectID, 7)
      XCTAssertEqual(mergeRequest.targetProjectID, 7)
      XCTAssertEqual(mergeRequest.labels, [])
      XCTAssertEqual(mergeRequest.workInProgress, false)
      XCTAssertNil(mergeRequest.milestone)
      XCTAssertEqual(mergeRequest.mergeWhenPipelineSucceeds, false)
      XCTAssertEqual(mergeRequest.sha, "f4afcfe641651408a8612c1fe704be6ef0427caf")
      XCTAssertEqual(mergeRequest.mergeStatus, "cannot_be_merged")
      XCTAssertNil(mergeRequest.mergeCommitSHA)
      XCTAssertEqual(mergeRequest.userNotesCount, 0)
      XCTAssertNil(mergeRequest.discussionLocked)
      XCTAssertNil(mergeRequest.shouldRemoveSourceBranch)
      XCTAssertEqual(mergeRequest.forceRemoveSourceBranch, false)
     
      XCTAssertNotNil(mergeRequest.timeStats)
      let timeStats = mergeRequest.timeStats!
      XCTAssertEqual(timeStats.timeEstimate, 0)
      XCTAssertEqual(timeStats.totalTimeSpent, 0)
      XCTAssertNil(timeStats.humanTimeEstimate)
      XCTAssertNil(timeStats.humanTotalTimeSpent)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
}
