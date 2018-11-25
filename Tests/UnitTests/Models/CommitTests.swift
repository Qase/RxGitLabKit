//
//  CommitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 04/10/2018.
//

import XCTest
import RxGitLabKit

class CommitTests: XCTestCase {

  private let decoder = JSONDecoder()
  private let calendar = Calendar(identifier: .gregorian)

  func testCommitDecoding() {
    guard let commit = try? decoder.decode(Commit.self, from: CommitsMocks.singleCommitResponseData) else {
      XCTFail("Failed to decode commit.")
      return
    }
    XCTAssertEqual(commit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
    XCTAssertEqual(commit.shortId, "6104942438c")
    XCTAssertEqual(commit.title, "Sanitize for network graph")
    XCTAssertEqual(commit.authorName, "randx")
    XCTAssertEqual(commit.authorEmail, "dmitriy.zaporozhets@gmail.com")
    XCTAssertEqual(commit.committerName, "Dmitriy")
    XCTAssertEqual(commit.committerEmail, "dmitriy.zaporozhets@gmail.com")
    XCTAssertEqual(commit.message, "Sanitize for network graph")
    XCTAssertNotNil(commit.parentIds)
    XCTAssertEqual(commit.parentIds!.count, 1)
    XCTAssertEqual(commit.parentIds!.first!, "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba")
    XCTAssertEqual(commit.status, "running")

    XCTAssertNotNil(commit.lastPipeline)
    let pipeline = commit.lastPipeline!
    XCTAssertEqual(pipeline.id, 8)
    XCTAssertEqual(pipeline.ref, "master")
    XCTAssertEqual(pipeline.sha, "2dc6aa325a317eda67812f05600bdf0fcdc70ab0")
    XCTAssertEqual(pipeline.status, "created")

    XCTAssertNotNil(commit.stats)
    let stats = commit.stats!
    XCTAssertEqual(stats.additions, 15)
    XCTAssertEqual(stats.deletions, 10)
    XCTAssertEqual(stats.total, 25)

    let timeZone = TimeZone(secondsFromGMT: 3*3600)
    let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12)
    let date = calendar.date(from: components)!

    XCTAssertEqual(commit.createdAt, date)
    XCTAssertEqual(commit.authoredDate, date)
    XCTAssertEqual(commit.committedDate, date)

  }

  func testTwoCommitDecoding() {
    guard let commits = try? decoder.decode([Commit].self, from: CommitsMocks.twoCommitsData) else {
      XCTFail("Failed to decode commits.")
      return
    }
    XCTAssertEqual(commits.count, 2)
    let firstCommit = commits[0]
    XCTAssertEqual(firstCommit.id, "ed899a2f4b50b4370feeea94676502b42383c746")
    XCTAssertEqual(firstCommit.shortId, "ed899a2f4b5")
    XCTAssertEqual(firstCommit.title, "Replace sanitize with escape once")
    XCTAssertEqual(firstCommit.authorName, "Dmitriy Zaporozhets")
    XCTAssertEqual(firstCommit.authorEmail, "dzaporozhets@sphereconsultinginc.com")
    XCTAssertEqual(firstCommit.committerName, "Administrator")
    XCTAssertEqual(firstCommit.committerEmail, "admin@example.com")
    XCTAssertEqual(firstCommit.message, "Replace sanitize with escape once")
    XCTAssertNotNil(firstCommit.parentIds)
    XCTAssertEqual(firstCommit.parentIds!.count, 1)
    XCTAssertEqual(firstCommit.parentIds!.first!, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
    XCTAssertNil(firstCommit.status)
    XCTAssertNil(firstCommit.lastPipeline)
    XCTAssertNil(firstCommit.stats)

    let timeZone = TimeZone(secondsFromGMT: 3*3600)
    let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 9, day: 20, hour: 11, minute: 50, second: 22)
    let date = calendar.date(from: components)!

    XCTAssertEqual(firstCommit.createdAt, date)
    XCTAssertEqual(firstCommit.authoredDate, date)
    XCTAssertEqual(firstCommit.committedDate, date)

    let secondCommit = commits[1]
    XCTAssertEqual(secondCommit.id, "6104942438c14ec7bd21c6cd5bd995272b3faff6")
    XCTAssertEqual(secondCommit.shortId, "6104942438c")
    XCTAssertEqual(secondCommit.title, "Sanitize for network graph")
    XCTAssertEqual(secondCommit.authorName, "randx")
    XCTAssertEqual(secondCommit.authorEmail, "dmitriy.zaporozhets@gmail.com")
    XCTAssertEqual(secondCommit.committerName, "Dmitriy")
    XCTAssertEqual(secondCommit.committerEmail, "dmitriy.zaporozhets@gmail.com")
    XCTAssertEqual(secondCommit.message, "Sanitize for network graph")
    XCTAssertNotNil(secondCommit.parentIds)
    XCTAssertEqual(secondCommit.parentIds!.count, 1)
    XCTAssertEqual(secondCommit.parentIds!.first!, "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba")
    XCTAssertNil(secondCommit.status)

    XCTAssertNil(secondCommit.lastPipeline)
    XCTAssertNil(secondCommit.stats)

    let date2 = calendar.date(from: DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12))!

    XCTAssertEqual(secondCommit.createdAt, date2)
    XCTAssertNil(secondCommit.authoredDate)
    XCTAssertNil(secondCommit.committedDate)

  }

  func testNewCommitEncoding() {
    let newCommit = NewCommit(branch: "master", commitMessage: "some commit message", actions: [
      Action(action: "create", filePath: "foo/bar", content: "some content"),
      Action(action: "delete", filePath: "foo/bar2"),
      Action(action: "move", filePath: "foo/bar3", previousPath: "foo/bar4", content: "some content"),
      Action(action: "update", filePath: "foo/bar5", content: "new content"),
      Action(action: "chmod", filePath: "foo/bar5", executeFileMode: true)
      ])
    let encoder = JSONEncoder()
    let data = try! encoder.encode(newCommit)
    print(String(data: data, encoding: .utf8)!)

    let decoder = JSONDecoder()
    guard let mockedNewCommit = try? decoder.decode(NewCommit.self, from: CommitsMocks.newCommit) else {
      XCTFail("Failed to decode new commit.")
      return
    }

    XCTAssertEqual(newCommit, mockedNewCommit)

  }

  func testNewCommitDecoding() {
    guard let newCommit = try? decoder.decode(NewCommit.self, from: CommitsMocks.newCommit) else {
      XCTFail("Failed to decode new commit.")
      return
    }

    XCTAssertNil(newCommit.id)
    XCTAssertEqual(newCommit.branch, "master")
    XCTAssertEqual(newCommit.commitMessage, "some commit message")
    XCTAssertNil(newCommit.startBranch)
    XCTAssertNil(newCommit.authorEmail)
    XCTAssertNil(newCommit.authorName)
    XCTAssertNotNil(newCommit.actions)
    XCTAssertEqual(newCommit.actions!.count, 5)
    XCTAssertEqual(newCommit.actions![2].action, "move")
    XCTAssertEqual(newCommit.actions![2].filePath, "foo/bar3")
    XCTAssertEqual(newCommit.actions![2].previousPath, "foo/bar4")
    XCTAssertEqual(newCommit.actions![2].content, "some content")

    XCTAssertEqual(newCommit.actions![4].action, "chmod")

    XCTAssertEqual(newCommit.actions![4].executeFileMode, true)

  }

  func testReferencesResponseDecoding() {
    guard let references = try? decoder.decode([Reference].self, from: CommitsMocks.referencesResponseData) else {
      XCTFail("Failed to decode references.")
      return
    }

    XCTAssertEqual(references.count, 4)
    XCTAssertEqual(references[0].type, "branch")
    XCTAssertEqual(references[0].name, "'test'")
    XCTAssertEqual(references[1].name, "add-balsamiq-file")
    XCTAssertEqual(references[3].type, "tag")
    XCTAssertEqual(references[3].name, "v1.1.0")
  }

  func testDiffResponseDecoding() {
    guard let diff = try? decoder.decode(Diff.self, from: CommitsMocks.diffData) else {
      XCTFail("Failed to decode references.")
      return
    }

    XCTAssertEqual(diff.diff, "--- a/doc/update/5.4-to-6.0.md +++ b/doc/update/5.4-to-6.0.md @@ -71,6 +71,8 @@ sudo -u git -H bundle exec rake migrate_keys RAILS_ENV=production sudo -u git -H bundle exec rake migrate_inline_notes RAILS_ENV=production +sudo -u git -H bundle exec rake gitlab:assets:compile RAILS_ENV=production+")
    XCTAssertEqual(diff.newPath, "doc/update/5.4-to-6.0.md")
    XCTAssertEqual(diff.oldPath, "doc/update/5.4-to-6.0.md")
    XCTAssertNil(diff.aMode)
    XCTAssertEqual(diff.bMode, "100644")
    XCTAssertNotNil(diff.newFile)
    XCTAssertNotNil(diff.renamedFile)
    XCTAssertNotNil(diff.deletedFile)
    XCTAssertFalse(diff.newFile!)
    XCTAssertFalse(diff.renamedFile!)
    XCTAssertFalse(diff.deletedFile!)
  }

  func testCommentDecoding() {
    guard let comments = try? decoder.decode([Comment].self, from: CommitsMocks.commentsData) else {
      XCTFail("Failed to decode references.")
      return
    }
    let comment = comments[0]
    XCTAssertEqual(comment.note, "this code is really nice")
    XCTAssertNotNil(comment.author)
    let author = comment.author!
    XCTAssertEqual(author.id, 11)
    XCTAssertEqual(author.username, "admin")
    XCTAssertEqual(author.email, "admin@local.host")
    XCTAssertEqual(author.name, "Administrator")
    XCTAssertEqual(author.state, "active")

    let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2014, month: 3, day: 6, hour: 8, minute: 17, second: 35))!
    XCTAssertEqual(author.createdAt, date)
  }

  func testCommentResponseDecoding() {
    guard let comment = try? decoder.decode(Comment.self, from: CommitsMocks.commentResponseData) else {
      XCTFail("Failed to decode references.")
      return
    }

    XCTAssertNotNil(comment.note, "this code is really nice")
    XCTAssertNotNil(comment.author)
    let author = comment.author!
    XCTAssertEqual(author.id, 28)
    XCTAssertEqual(author.username, "thedude")
    XCTAssertEqual(author.webUrl, "https://gitlab.example.com/thedude")
    XCTAssertEqual(author.avatarUrl, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
    XCTAssertEqual(author.name, "Jeff Lebowski")
    XCTAssertEqual(author.state, "active")

    let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2016, month: 1, day: 19, hour: 9, minute: 44, second: 55))!
    XCTAssertEqual(comment.createdAt, date)
  }

  func testCommitStatusesDecoding() {
    guard let statuses = try? decoder.decode([CommitStatus].self, from: CommitsMocks.commitStatusesData) else {
      XCTFail("Failed to decode references.")
      return
    }
    let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2016, month: 1, day: 19, hour: 8, minute: 40, second: 25))!

    XCTAssertEqual(statuses.count, 2)
    let firstStatus = statuses[0]
    XCTAssertEqual(firstStatus.status, "pending")
    XCTAssertEqual(firstStatus.createdAt, date)
    XCTAssertEqual(firstStatus.allowFailure, true)
    XCTAssertEqual(firstStatus.id, 91)
    XCTAssertEqual(firstStatus.sha, "18f3e63d05582537db6d183d9d557be09e1f90c8")
    XCTAssertNil(firstStatus.startedAt)
    XCTAssertNil(firstStatus.description)
    XCTAssertNil(firstStatus.finishedAt)
    XCTAssertNotNil(firstStatus.author)
    let author = firstStatus.author!
    XCTAssertEqual(author.id, 28)
    XCTAssertEqual(author.name, "Jeff Lebowski")
    XCTAssertEqual(author.webUrl, "https://gitlab.example.com/thedude")
    XCTAssertEqual(author.avatarUrl, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
  }

  func testCommitStatusDecoding() {
    guard let status = try? decoder.decode(CommitStatus.self, from: CommitsMocks.buildCommitStatusResponseData) else {
      XCTFail("Failed to decode references.")
      return
    }
    let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2016, month: 1, day: 19, hour: 9, minute: 5, second: 50))!

    XCTAssertEqual(status.status, "success")
    XCTAssertEqual(status.createdAt, date)
    XCTAssertEqual(status.finishedAt, date)
    XCTAssertEqual(status.coverage, 100.0)
    XCTAssertEqual(status.allowFailure, false)
    XCTAssertEqual(status.id, 93)
    XCTAssertEqual(status.sha, "18f3e63d05582537db6d183d9d557be09e1f90c8")
    XCTAssertNil(status.startedAt)
    XCTAssertNil(status.description)
    XCTAssertNotNil(status.author)
    let author = status.author!
    XCTAssertEqual(author.id, 28)
    XCTAssertEqual(author.name, "Jeff Lebowski")
    XCTAssertEqual(author.webUrl, "https://gitlab.example.com/thedude")
    XCTAssertEqual(author.avatarUrl, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
  }

  func testMergeRequestDecoding() {
    do {
      let mergeRequest = try decoder.decode(MergeRequest.self, from: CommitsMocks.mergeRequestData)
      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2018, month: 3, day: 26, hour: 17, minute: 26, second: 30))!

      XCTAssertEqual(mergeRequest.id, 45)
      XCTAssertEqual(mergeRequest.iid, 1)
      XCTAssertEqual(mergeRequest.projectID, 35)
      XCTAssertEqual(mergeRequest.title, "Add new file")
      XCTAssertEqual(mergeRequest.description, "")
      XCTAssertEqual(mergeRequest.state, "opened")
      XCTAssertEqual(mergeRequest.createdAt, date)
      XCTAssertEqual(mergeRequest.updatedAt, date)
      XCTAssertEqual(mergeRequest.targetBranch, "master")
      XCTAssertEqual(mergeRequest.sourceProjectID, 35)
      XCTAssertEqual(mergeRequest.targetProjectID, 35)
      XCTAssertEqual(mergeRequest.labels, [])
      XCTAssertEqual(mergeRequest.workInProgress, false)
      XCTAssertNil(mergeRequest.milestone)
      XCTAssertEqual(mergeRequest.mergeWhenPipelineSucceeds, false)
      XCTAssertEqual(mergeRequest.sha, "af5b13261899fb2c0db30abdd0af8b07cb44fdc5")
      XCTAssertEqual(mergeRequest.mergeStatus, "can_be_merged")
      XCTAssertNil(mergeRequest.mergeCommitSHA)
      XCTAssertEqual(mergeRequest.userNotesCount, 0)
      XCTAssertNil(mergeRequest.discussionLocked)
      XCTAssertNil(mergeRequest.shouldRemoveSourceBranch)
      XCTAssertEqual(mergeRequest.forceRemoveSourceBranch, false)
      XCTAssertEqual(mergeRequest.webURL, "http://https://gitlab.example.com/root/test-project/merge_requests/1")
      XCTAssertNotNil(mergeRequest.timeStats)
      let timeStats = mergeRequest.timeStats!
      XCTAssertEqual(timeStats.timeEstimate, 0)
      XCTAssertEqual(timeStats.totalTimeSpent, 0)
      XCTAssertEqual(timeStats.humanTimeEstimate, 1)
      XCTAssertEqual(timeStats.humanTotalTimeSpent, 2)
    } catch (let error) {
      XCTFail(error.localizedDescription)
    }
  }

  func testDecodingAllCommits() {
    var index = 0
    do {
      let decoder = JSONDecoder()
      for data in CommitsMocks.commitData {
        _ = try decoder.decode(Commit.self, from: data)
        index += 1
      }
    } catch(let error) {
      XCTFail("Error while decoding item with index \(index) \n Error:\(error.localizedDescription)")
    }
  }

}
