//
//  MultipleResponseMockURLSession.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 24/10/2018.
//

import Foundation
import RxGitLabKit

class MultipleResponseMockURLSession: URLSessionProtocol {
  
  var nextDataTask = MockURLSessionDataTask()
  var dataTaskResults: [(Data?, Error?, URLResponse?)]!
  
  private (set) var lastRequest: URLRequest?
  private (set) var lastURL: URL?
  
  init(with dataTaskResults: [(Data?, Error?, URLResponse?)] = []) {
    self.dataTaskResults = dataTaskResults
  }
  
  func successHttpURLResponse(request: URLRequest) -> URLResponse {
    return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
  }
  
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    lastRequest = request
    lastURL = request.url
    let dataTaskResult = dataTaskResults.count > 0 ? dataTaskResults.removeFirst() : (nil, nil, nil)
    
    
    completionHandler(dataTaskResult.0, dataTaskResult.2 ?? successHttpURLResponse(request: request), dataTaskResult.1)
    return nextDataTask
  }
}
