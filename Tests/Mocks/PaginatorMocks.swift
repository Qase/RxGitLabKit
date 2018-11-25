//
//  PaginatorMocks.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 24/10/2018.
//

import Foundation
import RxGitLabKit

class PaginatorMocks {

  static let commitJSONs: [String] = CommitsMocks.commitJSONs

  static let commits: [Commit] = CommitsMocks.commits

  static var totalElementsCount: Int {
    return commitJSONs.count
  }

  static func getHeader(page: Int, perPage: Int) -> Header {
    let header = [
      HeaderKeys.total.rawValue: "\(totalElementsCount)",
      HeaderKeys.totalPages.rawValue: "\(Int(ceil(Double(totalElementsCount) / Double(perPage))))",
      HeaderKeys.perPage.rawValue: "\(perPage)",
      HeaderKeys.page.rawValue: "\(max(page, 1))",
      HeaderKeys.nextPage.rawValue: "\(min(page + 1, totalElementsCount))",
      HeaderKeys.prevPage.rawValue: "\(max(page - 1, 0))"
    ]

    return header
  }

  static func getCommitPage(page: Int, perPage: Int) -> Data {
    guard let range = getPageRange(totalCount: totalElementsCount, page: page, perPage: perPage) else { return "[]".data()}
    let joinedStrings = "[ \(commitJSONs[range].joined(separator: ", ")) ]"

    return joinedStrings.data()
  }

  static func getCommitPage(page: Int, perPage: Int) -> [Commit] {
    guard let range = getPageRange(totalCount: totalElementsCount, page: page, perPage: perPage) else { return []}
    return Array(commits[range])
  }

  static func getPageRange(totalCount: Int, page: Int, perPage: Int) -> Range<Int>? {
    let _page = max(1, page)
    let _perPage = max(1, perPage)
    let startIndex = max((_page - 1) * perPage, 0)
    if startIndex >= totalCount {
      return nil
    }
    let endIndex = min(_page * _perPage, totalCount)
    if startIndex > endIndex {
      return nil
    }
    return startIndex..<endIndex
  }
}
