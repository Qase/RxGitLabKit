//
//  ContributorTests.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 04/01/2019.
//

import Foundation
import XCTest
import RxGitLabKit

class ContributorTests: BaseModelTestCase {
  
  func testContributorsDecode() {
    let contributorsData = """
[{"name":"Rintaro Ishizaki","email":"fs.output@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Michael Ilseman","email":"michael.ilseman@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Brent Royal-Gordon","email":"broyalgordon@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Rahul Malik","email":"rmalik@pinterest.com","commits":1,"additions":0,"deletions":0},{"name":"Max Desiatov","email":"max@desiatov.com","commits":1,"additions":0,"deletions":0},{"name":"Kyle Murray","email":"krilnon@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Bruno Cardoso Lopes","email":"bcardosolopes@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Jason Mittertreiner","email":"jason.mittertreiner@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Han Sang-jin","email":"tinysun.net@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Alex Blewitt","email":"alblue@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Nicholas Maccharoli","email":"nmaccharoli@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"Marc Rasi","email":"marcrasi@google.com","commits":1,"additions":0,"deletions":0},{"name":"Dante Broggi","email":"34220985+Dante-Broggi@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Karim Chang","email":"zykzzzz@hotmail.com","commits":1,"additions":0,"deletions":0},{"name":"levivic","email":"lzhang@ca.ibm.com","commits":1,"additions":0,"deletions":0},{"name":"adrian-prantl","email":"adrian-prantl@users.noreply.github.com","commits":1,"additions":0,"deletions":0},{"name":"Dave Abrahams","email":"dabrahams@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Devin Coughlin","email":"dcoughlin@apple.com","commits":1,"additions":0,"deletions":0},{"name":"Argyrios Kyrtzidis","email":"akyrtzi@gmail.com","commits":1,"additions":0,"deletions":0},{"name":"rposts","email":"rishi@ca.ibm.com","commits":1,"additions":0,"deletions":0}]
""".data()
    
    do {
      let contributors = try JSONDecoder().decode([Contributor].self, from: contributorsData)
      XCTAssertEqual(contributors.count, 20)
      XCTAssertEqual(contributors[5].name, "Kyle Murray")
      XCTAssertEqual(contributors[5].email, "krilnon@users.noreply.github.com")
      
    } catch let error {
      XCTFail("Failed to decode contributors. Error: \(error.localizedDescription)")
    }
  }
}
