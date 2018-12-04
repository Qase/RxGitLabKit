//
//  CommitsEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 27/11/2018.
//

import XCTest
@testable import RxGitLabKit
import RxAtomic
import RxSwift
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
      .toBlocking(timeout: defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      
      XCTAssertEqual(element.count, 1)
      guard let commits = element.first else {
        XCTFail("No data received.")
        return
      }
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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetCommit() {
    let commit = client.commits.getCommit(projectID: 7, sha: "12de97c73fd79017f281b97b1ecec041ce7e9416")
    let result = commit
      .toBlocking(timeout: defaultTimeout)
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
      if let stats = commit.stats {
        XCTAssertEqual(stats.additions, 12)
        XCTAssertEqual(stats.deletions, 12)
        XCTAssertEqual(stats.total, 24)
      } else {
        XCTFail("Stats should not be nil.")
      }
      
      let timeZone = TimeZone(secondsFromGMT: 0)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 27, hour: 2, minute: 22, second: 48)
      let date = calendar.date(from: components)!
      
      let authoredComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 26, hour: 22, minute: 33, second: 54)
      let authoredDate = calendar.date(from: authoredComponents)!
      XCTAssertEqual(commit.createdAt, date)
      XCTAssertEqual(commit.authoredDate, authoredDate)
      XCTAssertEqual(commit.committedDate, date)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testCreateCommit() {
    let commitMessage = "This is a commit message"
    let commitContent = "New commit content"
    let newCommit = NewCommit(branch: "master", commitMessage: commitMessage, startBranch: nil, actions: [Action(action: "update", filePath: "newcommit", previousPath: nil, content: commitContent, encoding: nil, lastCommitID: nil, executeFileMode: nil)])
    let result = client.commits.createCommit(projectID: 60, newCommit: newCommit)
      .toBlocking(timeout: defaultTimeout)
      .materialize()

    switch result {
    case .completed(elements: let element):
      guard let commit = element.first else {
        XCTFail("No commit created.")
        return
      }
      XCTAssertEqual(commit.message, commitMessage)
      XCTAssertEqual(commit.title, commitMessage)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetReferences() {
    let result = client.commits.getReferences(projectID: 50, sha: "86081d5582d440a5bf39931c15c08d940a783f6c", parameters: nil)
      .toBlocking(timeout: 20)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let references = element.first!
      XCTAssertEqual(references.count, 1)
      XCTAssertEqual(references[0].type, "branch")
      XCTAssertEqual(references[0].name, "master")
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetComments() {
    let result = client.commits.getComments(projectID: 7, sha: "12de97c73fd79017f281b97b1ecec041ce7e9416")
      .toBlocking(timeout: defaultTimeout)
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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testPostComment() {
    let note = "Nice picture man!"
    let lineType = "new"
    let path = "mock"
    let comment: Comment = Comment(note: note, lineType: lineType, line: 1, path: path)
    let result = client.commits.postComment(comment: comment, projectID: 60, sha: "master")
      .toBlocking(timeout: defaultTimeout)
      .materialize()

    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      guard let comment = element.first else {
        XCTFail("No comment received.")
        return
      }
      XCTAssertEqual(comment.note, note)
      XCTAssertNotNil(comment.author)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetStatuses() {
    let result = client.commits.getStatuses(projectID: 50, sha: "86081d5582d440a5bf39931c15c08d940a783f6c")
      .toBlocking(timeout: defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let element):

      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 11, day: 27, hour: 10, minute: 26, second: 32))!

      XCTAssertEqual(element.count, 1)
      guard let statuses = element.first, statuses.count > 0 else {
        XCTFail("No statuses data received.")
        return
      }
      
      let firstStatus = statuses[0]
      XCTAssertEqual(firstStatus.name, "test")
      XCTAssertEqual(firstStatus.status, "skipped")
      if let createdAt = firstStatus.createdAt {
        XCTAssertEqual(Int(createdAt.timeIntervalSinceReferenceDate), Int(date.timeIntervalSinceReferenceDate))
      } else {
        XCTFail("Created date is nil.")
      }
      XCTAssertEqual(firstStatus.allowFailure, false)
      XCTAssertEqual(firstStatus.id, 35)
      XCTAssertEqual(firstStatus.sha, "86081d5582d440a5bf39931c15c08d940a783f6c")
      XCTAssertEqual(firstStatus.ref, "master")
      XCTAssertNil(firstStatus.startedAt)
      XCTAssertNil(firstStatus.description)
      XCTAssertNil(firstStatus.finishedAt)
      XCTAssertNotNil(firstStatus.author)
      if let author = firstStatus.author {
        XCTAssertEqual(author.id, 1)
        XCTAssertEqual(author.name, "Administrator")
      } else {
        XCTFail("Author should not be nil.")
      }
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testPostStatus() {
    let projectID = 50
    let sha = "86081d5582d440a5bf39931c15c08d940a783f6c"
    let description = "description"
    let targetURL = "https://gitlab.test.com/some_path"
    let name = "A name"
    let coverage = 65.9
    let ref = "master"
    let state = BuildStatus.State.canceled.rawValue
    let status = BuildStatus(state: state, ref: ref, name: name, targetURL: targetURL, description: description, coverage: coverage)
    let result = client.commits.postStatus(status: status, projectID: projectID, sha: sha)
      .toBlocking(timeout: defaultTimeout)
      .materialize()

    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      guard let status = element.first else {
        XCTFail("No status received.")
        return
      }
      
      XCTAssertEqual(status.status, state)
      XCTAssertEqual(status.name, name)
      XCTAssertEqual(status.targetURL, targetURL)
      XCTAssertEqual(status.description, description)
      XCTAssertEqual(status.coverage, coverage)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetMergeRequests() {
    let result = client.commits.getMergeRequests(projectID: 7, sha: "f4afcfe641651408a8612c1fe704be6ef0427caf")
      .toBlocking(timeout: defaultTimeout)
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
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
}
