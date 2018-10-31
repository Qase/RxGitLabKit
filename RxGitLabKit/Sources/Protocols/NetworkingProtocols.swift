//
//  NetworkingProtocols.swift
//  RxGitLabKit-macOS
//
//  Created by Dagy Tran on 18/10/2018.
//

import Foundation
import RxSwift

public typealias QueryParameters = [String: Any]
public typealias JSONDictionary = [String: Any]
public typealias Header = [String : String]

public enum HeaderKeys: String {
  case total = "X-Total"
  case totalPages = "X-Total-Pages"
  case perPage = "X-Per-Page"
  case page = "X-Page"
  case nextPage = "X-Next-Page"
  case prevPage = "X-Prev-Page"
  case privateToken = "Private-Token"
  case oAuthToken = "Authorization"
}

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case update = "UPDATE"
  case patch = "PATCH"
  case head = "HEAD"
}

public enum HTTPError: Error {
  /// Bad Request - 400
  case badRequest
  
  /// Unauthorized Access - 401
  case unauthorized
  
  /// Forbidden Access - 403
  case forbidden
  
  /// Requested resource could not be found - 404
  case notFound
  
  /// A request method is not supported - 405
  case methodNotAllowed
  
  /// Server failed to fulfill a request - 5xx
  case serverFailure
  
  /// Unknown Error
  case unknown(Int?)
  
  /// JSON Parsing error.
  case parsingJSONFailure(error: Error)
  
  /// An invalid request
  case invalidRequest(message: String?)
  
  /// No Response
  case noResponse
  
  /// Non HTTP Response
  case nonHTTPResponse(response: URLResponse)
  
  /// No Data
  case noData
}

extension HTTPError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .badRequest:
      return NSLocalizedString("Bad Request", comment: "Bad") // 400
    case .unauthorized:
      return NSLocalizedString("Unauthorized", comment: "Unauthorized") // 401
    case .forbidden:
      return NSLocalizedString("Forbidden", comment: "Forbidden") // 403
    case .notFound:
      return NSLocalizedString("Not Found", comment: "Not") // 404
    case .methodNotAllowed:
      return NSLocalizedString("Method Not Allowed", comment: "Method") // 405
    case .serverFailure:
      return NSLocalizedString("Server Failure", comment: "Server") // 5xx
    case .unknown(let code):
      return NSLocalizedString("Unknown: \(code ?? -1)", comment: "Unknown: \(code ?? -1)")
    case .parsingJSONFailure(let error):
      return NSLocalizedString("Parsing JSON Failure: \(error)", comment: "Parsing JSON Failure")
    case .invalidRequest(let message):
      return NSLocalizedString("Invalid Request: \(message ?? "")", comment: "Invalid Request: \(message ?? "")")
    case .noResponse:
      return NSLocalizedString("No response from server", comment: "No response from server")
    case .nonHTTPResponse(let response):
      return NSLocalizedString("Non HTTP Response from URL: \(response.url?.absoluteString ?? "NO URL").", comment: "Non HTTP Response from URL: \(response.url?.absoluteString ?? "NO URL").")
    case .noData:
      return NSLocalizedString("No data returned.", comment: "No data returned.")
    }
  }
}

public protocol URLSessionProtocol {
  typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
  
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

//extension URLSessionProtocol: ReactiveComplatible {}

public protocol URLSessionDataTaskProtocol {
  func resume()
  func cancel()
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
  public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
