//
//  GeneralMocks.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 21/08/2018.
//

import Foundation

class GeneralMocks {
  static let errorJSONData = """
{"error":"invalid_request","error_description":"The request is missing a required parameter, includes an unsupported parameter value, or is otherwise malformed."}
""".data()

  static func successHttpURLResponse(request: URLRequest) -> URLResponse {
    return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
  }

  static let mockURL = URL(string: "https://gitlab.test.com")!

}
