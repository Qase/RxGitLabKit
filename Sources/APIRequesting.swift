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
  var data: Data? { get }
  
  func buildRequest(with hostURL: URL, header: Header?, apiVersion: String?, page: Int?, perPage: Int?) -> URLRequest?
}

extension APIRequesting {
  public func buildRequest(with hostURL: URL, header: Header? = nil, apiVersion: String? = RxGitLabAPIClient.apiVersionURLString, page: Int? = nil, perPage: Int? = nil) -> URLRequest? {
    var pathURL = hostURL
    if let apiVersion = apiVersion {
      pathURL.appendPathComponent(apiVersion)
    }
    if let path = path {
      pathURL.appendPathComponent(path)
    }

    guard var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: false) else { return nil }
    let dateFormatter = ISO8601DateFormatter()
    // Input query items
    if !parameters.isEmpty {
      components.queryItems = parameters.map { (arg) -> [URLQueryItem] in
        let (key, value) = arg
        switch value {
        case let bool as Bool:
          return [URLQueryItem(name: key, value: bool ? "true" : "false")]
        case let date as Date:
          return [URLQueryItem(name: key, value: dateFormatter.string(from: date))]
        case is Array<CustomStringConvertible>:
          return (value as! Array<CustomStringConvertible>).map {
            URLQueryItem(name: "\(key)[]", value: $0 as? String)
          }
        default:
          return [URLQueryItem(name: key, value: "\(value)")]
        }
        }.flatMap { $0 }
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
    if method == .post || method == .put  {
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    request.allHTTPHeaderFields = header
    if let jsonBody = jsonDictionary, let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) {
      request.httpBody = jsonData
    }

    if let data = data {
      request.httpBody = data
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

  public init(path: String = "",
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
