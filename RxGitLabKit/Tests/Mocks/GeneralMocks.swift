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
  
  static let mockLogin = ["username" : "tranaduc",
                          "password" : "nV4-ubr-M8V-LFx",
                          "oAuthToken" : "e379c3dd992dfb8043db912bb8ad6643130848184edad33358029a3176cabaec"
  ]
}
