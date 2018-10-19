//
//  MockURLSession.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 18/10/2018.
//

import Foundation
import RxGitLabKit

class MockURLSession: URLSessionProtocol {
  
  var nextDataTask = MockURLSessionDataTask()
  var nextData: Data?
  var nextError: Error?
  var urlResponse: URLResponse?
  
  private (set) var lastURL: URL?
  
  func successHttpURLResponse(request: URLRequest) -> URLResponse {
    return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
  }
  
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    lastURL = request.url
    
    completionHandler(nextData, urlResponse ?? successHttpURLResponse(request: request), nextError)
    return nextDataTask
  }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
  private (set) var resumeWasCalled = false
  
  func cancel() {}

  func resume() {
    resumeWasCalled = true
  }
}