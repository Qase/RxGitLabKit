//
//  APIRequesting.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 13/09/2018.
//

import Foundation

public protocol APIRequesting {
  var method: HTTPMethod { get }
  var path: String? { get }
  var parameters: QueryParameters { get }
  var jsonDictionary: JSONDictionary? {get}
}

extension APIRequesting {
  func buildRequest(with hostURL: URL, header: Header? = nil, apiVersion: String? = RxGitLabAPIClient.apiVersionURLString, page: Int? = nil, perPage: Int? = nil) -> URLRequest? {
    var pathURL = hostURL
    if let apiVersion = apiVersion {
      pathURL.appendPathComponent(apiVersion)
    }
    if let path = path {
      pathURL.appendPathComponent(path)
    }
    
    guard var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: false) else { return nil }
    
    if !parameters.isEmpty {
      components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    }
    if (page != nil || perPage != nil) && components.queryItems == nil {
      components.queryItems = []
      if let page = page {
        components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
      }
      
      if let perPage = perPage {
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
      }
    }

    
    guard let url = components.url else { return nil }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = method.rawValue
    if method == .post {
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    request.allHTTPHeaderFields = header
    if let jsonBody = jsonDictionary, let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) {
      request.httpBody = jsonData
    }
    
    return request
  }
}

public struct APIRequest: APIRequesting {
  public var method: HTTPMethod
  public var path: String?
  public var parameters: QueryParameters
  public var jsonDictionary: JSONDictionary?
  
  init(path: String = "",
       method: HTTPMethod = HTTPMethod.get,
       parameters: QueryParameters? = nil,
       jsonBody: JSONDictionary? = nil) {
    self.path = path
    self.method = method
    self.parameters = parameters ?? [:]
    self.jsonDictionary = jsonBody
  }
}
