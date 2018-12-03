//
//  ProjectsEndpointGroupUnitTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 04/11/2018.
//

import XCTest
@testable import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class ProjectsEndpointGroupUnitTests: EndpointGroupUnitTestCase {

  func testGetLanguages() {
    mockSession.nextData = ProjectMocks.languagesData
    let languages = client.projects.getLanguages(projectID: 4)
    let result = languages
      .toBlocking(timeout: 1)
      .materialize()

    switch result {
    case .completed(elements: let element):
      XCTAssertEqual(element.count, 1)
      let languages = element.first!
      print(languages)
      XCTAssertNotNil(languages["Ruby"])
      XCTAssertNotNil(languages["JavaScript"])
      XCTAssertNotNil(languages["HTML"])
      XCTAssertNotNil(languages["CoffeeScript"])
      XCTAssertEqual(languages["Ruby"]!, 66.69)
      XCTAssertEqual(languages["JavaScript"]!, 22.98)
      XCTAssertEqual(languages["HTML"]!, 7.91)
      XCTAssertEqual(languages["CoffeeScript"]!, 2.42)

    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }

}
