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
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    // Input query items
    if !parameters.isEmpty {
      components.queryItems = parameters.map { (key, value) -> URLQueryItem in
        switch value {
        case let bool as Bool:
          return URLQueryItem(name: key, value: bool ? "true" : "false")
        case let date as Date:
          return URLQueryItem(name: key, value: dateFormatter.string(from: date))
        case is Array<CustomStringConvertible>:
          return URLQueryItem(name: key, value: (value as! Array<CustomStringConvertible>).map { "\($0)"}.joined(separator: ","))
        default:
          return URLQueryItem(name: key, value: "\(value)")
        }
      }
    }
    
    // Pagination query items
    if (page != nil || perPage != nil) && components.queryItems == nil {
      components.queryItems = []
      if let page = page {
        components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
      }
      
      if let perPage = perPage {
        components.queryItems?.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
      }
    }
    
    // Request from url
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
  public var data: Data?
  
  init(path: String = "",
       method: HTTPMethod = HTTPMethod.get,
       parameters: QueryParameters? = nil,
       jsonBody: JSONDictionary? = nil,
       data: Data? = nil) {
    self.path = path
    self.method = method
    self.parameters = parameters ?? [:]
    self.jsonDictionary = jsonBody
    self.data = data
  }
}
