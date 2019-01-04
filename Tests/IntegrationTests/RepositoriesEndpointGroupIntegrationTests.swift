//
//  RepositoriesEndpointGroupIntegrationTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 29/11/2018.
//

import Foundation
import XCTest
@testable import RxGitLabKit
import RxSwift

class RepositoriesEndpointGroupIntegrationTests: BaseIntegrationTestCase {
  
  func testGetTree() {
    let result = client.repositories.getTree(projectID: 3)
      .loadAll()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let treeNodes = elements.first else {
        XCTFail("Tree nodes not received.")
        return
      }
      XCTAssertEqual(treeNodes.count, 36)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetComparison() {
    let result = client.repositories.getComparison(projectID: 3, from: "master", to: "develop")
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let comparison = elements.first else {
        XCTFail("Comparison not received.")
        return
      }
      XCTAssertNotNil(comparison.commit)
      XCTAssertEqual(comparison.commits.count, 4)
      XCTAssertEqual(comparison.diffs.count, 4)

    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetContributors() {
    let result = client.repositories.getContributors(projectID: 3, perPage: 100)
      .loadAll()
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let contributors = elements.first else {
        XCTFail("Contributors not received.")
        return
      }
      XCTAssertEqual(contributors.count, 272)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testContributorsDecode() {
    let contributorsData = """
[{"name":"Rintaro Ishizaki","email":"fs.output@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Michael Ilseman","email":"michael.ilseman@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Brent Royal-Gordon","email":"broyalgordon@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Rahul Malik","email":"rmalik@pinterest.com","commits":1,"additions":0,"deletions":0},{"name":"Max Desiatov","email":"max@desiatov.com","commits":1,"additions":0,"deletions":0},{"name":"Kyle Murray","email":"krilnon@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Bruno Cardoso Lopes","email":"bcardosolopes@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Jason Mittertreiner","email":"jason.mittertreiner@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Han Sang-jin","email":"tinysun.net@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Alex Blewitt","email":"alblue@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Nicholas Maccharoli","email":"nmaccharoli@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Marc Rasi","email":"marcrasi@google.com","commits":1,"additions":0,"deletions":0},{"name":"Dante Broggi","email":"34220985+Dante-Broggi@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Karim Chang","email":"zykzzzz@hotmail.com","commits":1,"additions":0,"deletions":0},{"name":"levivic","email":"lzhang@ca.ibm.com","commits":1,"additions":0,"deletions":0},{"name":"adrian-prantl","email":"adrian-prantl@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Dave Abrahams","email":"dabrahams@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Devin Coughlin","email":"dcoughlin@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Argyrios Kyrtzidis","email":"akyrtzi@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"rposts","email":"rishi@ca.ibm.com","commits":1,"additions":0,"deletions":0}]
""".data()
    
    let contributors = try? JSONDecoder().decode([Contributor].self, from: contributorsData)
//    print(contributors!)
  }
  
  func testGetMergeBase() {
    let result = client.repositories.getMergeBase(projectID: 3, refs: ["master", "develop"])
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let mergeBase = elements.first else {
        XCTFail("Merge base not received.")
        return
      }
      XCTAssertEqual(mergeBase.id, "e8aa1d892a0d8a153a28b74cbad25be534926f49")
      XCTAssertEqual(mergeBase.title, "Release 4.4.0")
      XCTAssertEqual(mergeBase.authorName, "Krunoslav Zaher")
      
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetFileInfo() {
    let result = client.repositories.getFileInfo(projectID: 3, filePath: "LICENSE.md", ref: "master")
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let fileInfo = elements.first else {
        XCTFail("FileInfo not received.")
        return
      }
      XCTAssertEqual(fileInfo.size, 1106)
      XCTAssertEqual(fileInfo.encoding, "base64")
      XCTAssertEqual(fileInfo.ref, "master")
      XCTAssertEqual(fileInfo.blobID, "d6765d9c9b9b7920372d1d45507118878184df83")
      XCTAssertNotNil(fileInfo.content)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
  
  func testGetFile() {
    let result = client.repositories.getFile(projectID: 3, filePath: "LICENSE.md", ref: "master")
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      guard let data = elements.first else {
        XCTFail("No datareceived.")
        return
      }
      XCTAssertNotNil(String(data: data, encoding: .utf8))
      XCTAssertEqual(data.count, 1106)
    case .failed(elements: _, error: let error):
      XCTFail((error as? HTTPError)?.errorDescription ?? error.localizedDescription)
    }
  }
}
