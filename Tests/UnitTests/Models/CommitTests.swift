//
//  CommitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 04/10/2018.
//

import XCTest
import RxGitLabKit

class CommitTests: BaseModelTestCase {
  
  func testCommitDecoding() {
    do {
      let commit = try decoder.decode(Commit.self, from: CommitsMocks.singleCommitResponseData)
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
    } catch let error {
      XCTFail("Failed to decode commit. \n Error:\(error.localizedDescription)")
    }
    
  }
  
  func testTwoCommitDecoding() {
    do {
      let commits = try decoder.decode([Commit].self, from: CommitsMocks.twoCommitsData)
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
    } catch(let error) {
      XCTFail("Error while decoding commits \n Error:\(error.localizedDescription)")
    }
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
    do {
      let mockedNewCommit = try decoder.decode(NewCommit.self, from: CommitsMocks.newCommit)
      
      XCTAssertEqual(newCommit, mockedNewCommit)
    } catch(let error) {
      XCTFail("Error while decoding new commit. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testNewCommitDecoding() {
    do {
      let newCommit = try decoder.decode(NewCommit.self, from: CommitsMocks.newCommit)
      
      XCTAssertEqual(newCommit.branch, "master")
      XCTAssertEqual(newCommit.commitMessage, "some commit message")
      XCTAssertNil(newCommit.startBranch)
      XCTAssertNil(newCommit.authorEmail)
      XCTAssertNil(newCommit.authorName)
      XCTAssertNotNil(newCommit.actions)
      XCTAssertEqual(newCommit.actions.count, 5)
      XCTAssertEqual(newCommit.actions[2].action, "move")
      XCTAssertEqual(newCommit.actions[2].filePath, "foo/bar3")
      XCTAssertEqual(newCommit.actions[2].previousPath, "foo/bar4")
      XCTAssertEqual(newCommit.actions[2].content, "some content")
      XCTAssertEqual(newCommit.actions[4].action, "chmod")
      XCTAssertEqual(newCommit.actions[4].executeFileMode, true)
    } catch(let error) {
      XCTFail("Error while decoding new commit. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testReferencesResponseDecoding() {
    
    do {
      let references = try decoder.decode([Reference].self, from: CommitsMocks.referencesResponseData)
      
      XCTAssertEqual(references.count, 4)
      XCTAssertEqual(references[0].type, "branch")
      XCTAssertEqual(references[0].name, "'test'")
      XCTAssertEqual(references[1].name, "add-balsamiq-file")
      XCTAssertEqual(references[3].type, "tag")
      XCTAssertEqual(references[3].name, "v1.1.0")
    } catch(let error) {
      XCTFail("Error while decoding references. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testDiffResponseDecoding() {
    do {
      let diff = try decoder.decode(Diff.self, from: CommitsMocks.diffData)
      
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
    } catch(let error) {
      XCTFail("Error while decoding a diff. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testCommentDecoding() {
    do {
      let comments = try decoder.decode([Comment].self, from: CommitsMocks.commentsData)
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
    } catch(let error) {
      XCTFail("Error while decoding comments. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testCommentResponseDecoding() {
    do {
      let comment = try decoder.decode(Comment.self, from: CommitsMocks.commentResponseData)
      
      XCTAssertNotNil(comment.note, "this code is really nice")
      XCTAssertNotNil(comment.author)
      let author = comment.author!
      XCTAssertEqual(author.id, 28)
      XCTAssertEqual(author.username, "thedude")
      XCTAssertEqual(author.webURL, "https://gitlab.example.com/thedude")
      XCTAssertEqual(author.avatarURL, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
      XCTAssertEqual(author.name, "Jeff Lebowski")
      XCTAssertEqual(author.state, "active")
      
      let date = calendar.date(from: DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0), year: 2016, month: 1, day: 19, hour: 9, minute: 44, second: 55))!
      XCTAssertEqual(comment.createdAt, date)
    } catch(let error) {
      XCTFail("Error while decoding comment response. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testCommitStatusesDecoding() {
    do {
      
      let statuses = try decoder.decode([CommitStatus].self, from: CommitsMocks.commitStatusesData)
      
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
      XCTAssertEqual(author.webURL, "https://gitlab.example.com/thedude")
      XCTAssertEqual(author.avatarURL, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
    } catch(let error) {
      XCTFail("Error while decoding new statuses. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testCommitStatusDecoding() {
    do {
      let status = try decoder.decode(CommitStatus.self, from: CommitsMocks.buildCommitStatusResponseData)
      
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
      XCTAssertEqual(author.webURL, "https://gitlab.example.com/thedude")
      XCTAssertEqual(author.avatarURL, "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png")
      
      
    } catch(let error) {
      XCTFail("Error while decoding commit status. \n Error:\(error.localizedDescription)")
    }
  }
  
  func testDecodingAllCommits() {
    var index = 0
    do {
      for data in CommitsMocks.commitData {
        _ = try decoder.decode(Commit.self, from: data)
        index += 1
      }
    } catch(let error) {
      XCTFail("Error while decoding item with index \(index) \n Error:\(error.localizedDescription)")
    }
  }
}
