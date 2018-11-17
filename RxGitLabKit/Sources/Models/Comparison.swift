//
//  Comparison.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 17/11/2018.
//

import Foundation

public struct Comparison: Codable {
    let commit: Commit
    let commits: [Commit]
    let diffs: [Diff]
    let compareTimeout, compareSameRef: Bool

    enum CodingKeys: String, CodingKey {
        case commit, commits, diffs
        case compareTimeout = "compare_timeout"
        case compareSameRef = "compare_same_ref"
    }
}
