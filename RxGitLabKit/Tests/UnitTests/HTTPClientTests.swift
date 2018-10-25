//
//  HTTPClientTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 19/10/2018.
//

import XCTest
import RxGitLabKit
import RxSwift
import RxBlocking
import RxTest

class HTTPClientTests: XCTestCase {
  
  struct MockStruct: Codable {
    let key: String
  }

  private var mockSession: MockURLSession!
  private var client: HTTPClient!
  private let mockURL = GeneralMocks.mockURL
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    mockSession = MockURLSession()
    client = HTTPClient(using: mockSession)
  }
  
  func testResponse() {
    let request = URLRequest(url: mockURL)
    let headerFields = [
      "Content-Type" : "application/json",
      ]
    let nextData = CommitsMocks.commentsData
    mockSession.urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headerFields)
    mockSession.nextData = nextData
    
    let result = client.response(for: request)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements.count, 1)
      let pair = elements.first!
      let response = pair.0
      XCTAssertNotNil(response.allHeaderFields["Content-Type"])
      XCTAssertTrue(response.allHeaderFields["Content-Type"] is String)
      XCTAssertEqual(response.allHeaderFields["Content-Type"] as! String, "application/json")
      let receivedData = pair.1
      XCTAssertEqual(nextData, receivedData)
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testResponseError() {
    let response = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    let responses: [(URLResponse?, HTTPError)] = [
      (nil, HTTPError.noResponse),
      (response, HTTPError.nonHTTPResponse(response: response))
    ]
    
    responses.forEach { (response, error) in
      mockSession.urlResponse = response
      mockSession.isNilResponseForced = response == nil
      let result = client.response(for: URLRequest(url: mockURL))
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        XCTFail("This should have failed, but got a response instead. \(elements) received")
      case .failed(elements: _, error: let err):
        XCTAssertEqual(err.localizedDescription, error.localizedDescription)
      }
    }
  }
  
  func testHeader() {
    let headerFields = [
      "Content-Type" : "application/json",
      "X-Content-Type-Options": "nosniff",
      "X-Frame-Options": "SAMEORIGIN",
      "X-Next-Page": "4",
      "X-Page": "3",
      "X-Per-Page": "100",
      "X-Prev-Page": "2",
      "X-Request-Id": "ca096ba8-6cbc-4386-8c75-187b0d60443d",
      "X-Runtime": "0.611078",
      "X-Total": "3016",
      "X-Total-Pages": "31"
    ]
    
    mockSession.urlResponse = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headerFields)!
    
    let result = client.header(for: URLRequest(url: mockURL))
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements.count, 1)
      let header = elements.first!
      XCTAssertEqual(header.count, 11)
      XCTAssertNotNil(header["Content-Type"])
      XCTAssertNotNil(header["X-Content-Type-Options"])
      XCTAssertNotNil(header["X-Frame-Options"])
      XCTAssertNotNil(header["X-Next-Page"])
      XCTAssertNotNil(header["X-Page"])
      XCTAssertNotNil(header["X-Per-Page"])
      XCTAssertNotNil(header["X-Prev-Page"])
      XCTAssertNotNil(header["X-Request-Id"])
      XCTAssertNotNil(header["X-Runtime"])
      XCTAssertNotNil(header["X-Total"])
      XCTAssertNotNil(header["X-Total-Pages"])
      
      XCTAssertEqual(header["X-Content-Type-Options"], "nosniff")
      XCTAssertEqual(header["X-Frame-Options"], "SAMEORIGIN")
      XCTAssertEqual(header["X-Next-Page"], "4")
      XCTAssertEqual(header["X-Page"], "3")
      XCTAssertEqual(header["X-Per-Page"], "100")
      XCTAssertEqual(header["X-Prev-Page"], "2")
      XCTAssertEqual(header["X-Request-Id"], "ca096ba8-6cbc-4386-8c75-187b0d60443d")
      XCTAssertEqual(header["X-Runtime"], "0.611078")
      XCTAssertEqual(header["X-Total"], "3016")
      XCTAssertEqual(header["X-Total-Pages"], "31")
    case .failed(elements: _, error: let error):
      XCTFail(error.localizedDescription)
    }
  }
  
  func testHeaderErrorCodes() {
    let response = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    
    let responses: [(URLResponse?, HTTPError)] = [
      (nil, HTTPError.noResponse),
      (response, HTTPError.nonHTTPResponse(response: response)),
      (HTTPURLResponse(url: mockURL, statusCode: 400, httpVersion: nil, headerFields: nil), HTTPError.badRequest),
      (HTTPURLResponse(url: mockURL, statusCode: 401, httpVersion: nil, headerFields: nil), HTTPError.unauthorized),
      (HTTPURLResponse(url: mockURL, statusCode: 403, httpVersion: nil, headerFields: nil), HTTPError.forbidden),
      (HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil), HTTPError.notFound),
      (HTTPURLResponse(url: mockURL, statusCode: 500, httpVersion: nil, headerFields: nil), HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 550, httpVersion: nil, headerFields: nil), HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 1, httpVersion: nil, headerFields: nil), HTTPError.unknown(1)),
      (HTTPURLResponse(url: mockURL, statusCode: 100, httpVersion: nil, headerFields: nil), HTTPError.unknown(100)),
      ]
    
    responses.forEach { (response, error) in
      mockSession.urlResponse = response
      mockSession.isNilResponseForced = response == nil

      let result = client.header(for: URLRequest(url: mockURL))
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        XCTFail("This should have failed, but got a response instead. \(elements) received")
      case .failed(elements: _, error: let err):
        XCTAssertEqual(err.localizedDescription, error.localizedDescription)
      }
    }
  }
  
  
  func testData() {
    let mockData = """
    { "hello": "world" }
    """.data()
    let request = URLRequest(url: mockURL)
    mockSession.nextData = mockData
    let result = client.data(for: request)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      let data = elements.first!
      XCTAssertEqual(data, mockData)
    case .failed(elements: _, error: let err):
      XCTFail(err.localizedDescription)
    }
  }
  
  
  func testDataErrorCodes() {
    let mockData = """
    { "hello": "world" }
    """.data()
    
    let nonHTTPResponse = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    
    let responses: [(URLResponse?,Data?, HTTPError)] = [
      (nil, mockData, HTTPError.noResponse),
      (nonHTTPResponse,mockData, HTTPError.nonHTTPResponse(response: nonHTTPResponse)),
      (HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil), nil , HTTPError.noData),
      (HTTPURLResponse(url: mockURL, statusCode: 400, httpVersion: nil, headerFields: nil), mockData , HTTPError.badRequest),
      (HTTPURLResponse(url: mockURL, statusCode: 401, httpVersion: nil, headerFields: nil), mockData, HTTPError.unauthorized),
      (HTTPURLResponse(url: mockURL, statusCode: 403, httpVersion: nil, headerFields: nil), mockData, HTTPError.forbidden),
      (HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil), mockData, HTTPError.notFound),
      (HTTPURLResponse(url: mockURL, statusCode: 500, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 550, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 1, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(1)),
      (HTTPURLResponse(url: mockURL, statusCode: 100, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(100)),
      ]
    
    responses.forEach { (response, data, error) in
      mockSession.nextData = data
      mockSession.urlResponse = response
      mockSession.isNilResponseForced = response == nil

      let result = client.data(for: URLRequest(url: mockURL))
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        XCTFail("This should have failed, but got a response instead. \(elements) received")
      case .failed(elements: _, error: let err):
        XCTAssertEqual(err.localizedDescription, error.localizedDescription)
      }
    }
  }
  
  func testObject() {
    let mockData = """
    { "key": "hello world" }
    """.data()
    let request = URLRequest(url: mockURL)
    mockSession.nextData = mockData

    let result = (client.object(for: request) as Observable<MockStruct>)
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      let mockStruct = elements.first!
      XCTAssertEqual(mockStruct.key, "hello world")
    case .failed(elements: _, error: let err):
      XCTFail(err.localizedDescription)
    }
    
    let corruptedData = """
    { "key": : "hello world" }
    """.data()
    
    mockSession.nextData = corruptedData
    let result2 = (client.object(for: request) as Observable<MockStruct>)
      .toBlocking()
      .materialize()
    
    switch result2 {
    case .completed(elements: let elements):
      XCTFail("Corrupted data should not be able to be decoded. Elements: \(elements)")
    case .failed(elements: _, error: let err):
      print(err.localizedDescription)
      XCTAssertTrue(err.localizedDescription.contains("Parsing JSON Failure: dataCorrupted"))
    }
    
    
  }
  
  func testObjectErrorCodes() {
    let mockData = """
    { "key": "hello world" }
    """.data()
    
    let nonHTTPResponse = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    
    let responses: [(URLResponse?, Data?, HTTPError)] = [
      (nil, mockData, HTTPError.noResponse),
      (nonHTTPResponse,mockData, HTTPError.nonHTTPResponse(response: nonHTTPResponse)),
      (HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil), nil , HTTPError.noData),
      (HTTPURLResponse(url: mockURL, statusCode: 400, httpVersion: nil, headerFields: nil), mockData , HTTPError.badRequest),
      (HTTPURLResponse(url: mockURL, statusCode: 401, httpVersion: nil, headerFields: nil), mockData, HTTPError.unauthorized),
      (HTTPURLResponse(url: mockURL, statusCode: 403, httpVersion: nil, headerFields: nil), mockData, HTTPError.forbidden),
      (HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil), mockData, HTTPError.notFound),
      (HTTPURLResponse(url: mockURL, statusCode: 500, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 550, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 1, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(1)),
      (HTTPURLResponse(url: mockURL, statusCode: 100, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(100)),
      ]
    
    responses.forEach { (response, data, error) in
      mockSession.nextData = data
      mockSession.urlResponse = response
      mockSession.isNilResponseForced = response == nil

      let result = (client.object(for: URLRequest(url: mockURL)) as Observable<MockStruct>)
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        XCTFail("This should have failed, but got a response instead. \(elements) received")
      case .failed(elements: _, error: let err):
        XCTAssertEqual(err.localizedDescription, error.localizedDescription)
      }
    }
  }
  
  func testJSON() {
    
    let mockData = """
    { "key": "hello world",
      "number" : 4,
      "bool" : true
    }
    """.data()
    let request = URLRequest(url: mockURL)
    
    mockSession.nextData = mockData
    let result = client.json(for: URLRequest(url: mockURL))
      .toBlocking()
      .materialize()
    
    switch result {
    case .completed(elements: let elements):
      XCTAssertEqual(elements.count, 1)
      let jsonDict = elements.first!
      XCTAssertNotNil(jsonDict["key"])
      XCTAssertNotNil(jsonDict["number"])
      XCTAssertNotNil(jsonDict["bool"])
      
      XCTAssertTrue(jsonDict["key"]! is String)
      XCTAssertTrue(jsonDict["number"]! is Int)
      XCTAssertTrue(jsonDict["bool"]! is Bool)
      
      XCTAssertEqual(jsonDict["key"] as! String, "hello world")
      XCTAssertEqual(jsonDict["number"] as! Int, 4)
      XCTAssertEqual(jsonDict["bool"] as! Bool, true)
    case .failed(elements: _, error: let err):
      XCTFail(err.localizedDescription)
    }
    
    let corruptedData = """
    { "key": : "hello world" }
    """.data()
    
    mockSession.nextData = corruptedData
    let result2 = client.json(for: request)
      .toBlocking()
      .materialize()
    
    switch result2 {
    case .completed(elements: let elements):
      XCTFail("Corrupted data should not be able to be decoded. Elements: \(elements)")
    case .failed(elements: _, error: let err):
      print(err.localizedDescription)
      XCTAssertTrue(err.localizedDescription.contains("Parsing JSON Failure:"))
    }
  }
  
  func testJSONErrorCodes() {
    let mockData = """
    { "key": "hello world" }
    """.data()
    
    let nonHTTPResponse = URLResponse(url: mockURL, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
    
    let responses: [(URLResponse?, Data?, HTTPError)] = [
      (nil, mockData, HTTPError.noResponse),
      (nonHTTPResponse,mockData, HTTPError.nonHTTPResponse(response: nonHTTPResponse)),
      (HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil), nil , HTTPError.noData),
      (HTTPURLResponse(url: mockURL, statusCode: 400, httpVersion: nil, headerFields: nil), mockData , HTTPError.badRequest),
      (HTTPURLResponse(url: mockURL, statusCode: 401, httpVersion: nil, headerFields: nil), mockData, HTTPError.unauthorized),
      (HTTPURLResponse(url: mockURL, statusCode: 403, httpVersion: nil, headerFields: nil), mockData, HTTPError.forbidden),
      (HTTPURLResponse(url: mockURL, statusCode: 404, httpVersion: nil, headerFields: nil), mockData, HTTPError.notFound),
      (HTTPURLResponse(url: mockURL, statusCode: 500, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 550, httpVersion: nil, headerFields: nil), mockData, HTTPError.serverFailure),
      (HTTPURLResponse(url: mockURL, statusCode: 1, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(1)),
      (HTTPURLResponse(url: mockURL, statusCode: 100, httpVersion: nil, headerFields: nil), mockData, HTTPError.unknown(100)),
      ]
    
    responses.forEach { (response, data, error) in
      mockSession.nextData = data
      mockSession.urlResponse = response
      mockSession.isNilResponseForced = response == nil

      let result = (client.object(for: URLRequest(url: mockURL)) as Observable<MockStruct>)
        .toBlocking()
        .materialize()
      
      switch result {
      case .completed(elements: let elements):
        XCTFail("This should have failed, but got a response instead. \(elements) received")
      case .failed(elements: _, error: let err):
        XCTAssertEqual(err.localizedDescription, error.localizedDescription)
      }
    }
  }
  
}
