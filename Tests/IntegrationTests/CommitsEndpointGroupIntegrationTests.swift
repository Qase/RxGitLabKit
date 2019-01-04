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

class CommitsEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  let calendar = Calendar(identifier: .gregorian)

  override func tearDown() {
  }
  
  func testGetCommits() {
    let paginator = client.commits.getCommits(projectID: 3)
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
      XCTAssertEqual(firstCommit.id, "bf83288eefa9b442b0541965d843f2b3433cc196")
      XCTAssertEqual(firstCommit.shortId, "bf83288e")
      XCTAssertEqual(firstCommit.title, "Fix typo in error message (#1810)")
      XCTAssertNotNil(firstCommit.authoredDate)
      XCTAssertNotNil(firstCommit.committedDate)
      XCTAssertNotNil(firstCommit.createdAt)
      XCTAssertEqual(firstCommit.parentIds?.count, 1)
      
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetCommit() {
    let commit = client.commits.getCommit(projectID: 3, sha: "e8aa1d892a0d8a153a28b74cbad25be534926f49")
    let result = commit
      .toBlocking(timeout: defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let commit = element.first!
      XCTAssertEqual(commit.id, "e8aa1d892a0d8a153a28b74cbad25be534926f49")
      XCTAssertEqual(commit.shortId, "e8aa1d89")
      XCTAssertEqual(commit.title, "Release 4.4.0")
      XCTAssertEqual(commit.authorName, "Krunoslav Zaher")
      XCTAssertEqual(commit.authorEmail, "krunoslav.zaher@gmail.com")
      XCTAssertEqual(commit.committerName, "Krunoslav Zaher")
      XCTAssertEqual(commit.committerEmail, "krunoslav.zaher@gmail.com")
      XCTAssertEqual(commit.message, "Release 4.4.0\n")
      XCTAssertNotNil(commit.parentIds)
      XCTAssertEqual(commit.parentIds!.count, 1)
      XCTAssertEqual(commit.parentIds!.first!, "78c500c9edea08ac4253d2d1cd0b9cf3a6cf370e")
      XCTAssertNil(commit.lastPipeline)
      XCTAssertNil(commit.status)
      XCTAssertNotNil(commit.stats)
      if let stats = commit.stats {
        XCTAssertEqual(stats.additions, 42)
        XCTAssertEqual(stats.deletions, 54)
        XCTAssertEqual(stats.total, 96)
      } else {
        XCTFail("Stats should not be nil.")
      }
      
      let timeZone = TimeZone(secondsFromGMT: 0)
      let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 1, hour: 21, minute: 26, second: 34)
      let date = calendar.date(from: components)!
      
      let authoredComponents = DateComponents(calendar: calendar, timeZone: timeZone, year: 2018, month: 11, day: 1, hour: 19, minute: 49, second: 44)
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
    let result = client.commits.getComments(projectID: 60, sha: "da1e4ccf58694b180675b2836d257cf5954681cf")
      .toBlocking(timeout: defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let comments = element.first!
      XCTAssertEqual(comments.count, 2)
      let comment = comments.first!
      XCTAssertEqual(comment.note, "Nice picture man!")
      XCTAssertNotNil(comment.author)
      let author = comment.author!
      XCTAssertEqual(author.id, 1)
      XCTAssertEqual(author.username, "root")
      XCTAssertEqual(author.name, "Administrator")
      
      let comment2 = comments[1]
      XCTAssertEqual(comment2.note, "Mock comment")
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
    let result = client.commits.getMergeRequests(projectID: 3, sha: "cf781b6eed988e68ea36037c9ce68273062666df")
      .toBlocking(timeout: defaultTimeout)
      .materialize()
    
    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let mergeRequest = element.first!.first!
      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2019, month: 1, day: 4, hour: 10, minute: 6, second: 10))!
      
      XCTAssertEqual(mergeRequest.id, 2)
      XCTAssertEqual(mergeRequest.iid, 1)
      XCTAssertEqual(mergeRequest.projectID, 3)
      XCTAssertEqual(mergeRequest.title, "Develop to master")
      XCTAssertEqual(mergeRequest.description, "")
      XCTAssertEqual(mergeRequest.state, "opened")
      XCTAssertDateEqual(mergeRequest.createdAt, date)
      XCTAssertDateEqual(mergeRequest.updatedAt, date)
      XCTAssertEqual(mergeRequest.targetBranch, "master")
      XCTAssertEqual(mergeRequest.sourceProjectID, 3)
      XCTAssertEqual(mergeRequest.targetProjectID, 3)
      XCTAssertEqual(mergeRequest.labels, [])
      XCTAssertEqual(mergeRequest.workInProgress, false)
      XCTAssertNil(mergeRequest.milestone)
      XCTAssertEqual(mergeRequest.mergeWhenPipelineSucceeds, false)
      XCTAssertEqual(mergeRequest.sha, "cf781b6eed988e68ea36037c9ce68273062666df")
      XCTAssertEqual(mergeRequest.mergeStatus, "can_be_merged")
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
