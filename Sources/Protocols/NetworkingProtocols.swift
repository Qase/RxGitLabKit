//
//  NetworkingProtocols.swift
//  RxGitLabKit-macOS
//
//  Created by Dagy Tran on 18/10/2018.
//

import Foundation
import RxSwift

/// Query Parameters
public typealias QueryParameters = [String: Any]

/// Dictionary representing a JSON object
public typealias JSONDictionary = [String: Any]

/// HTTP Header
public typealias Header = [String: String]

/// Main HTTP Header keys returned from server
public enum HeaderKeys: String {
  
  /// Total number of items
  case total = "X-Total"
  
  /// Total number of pages
  case totalPages = "X-Total-Pages"
  
  /// Maximum number of objects on one page
  case perPage = "X-Per-Page"
  
  /// Current page number
  case page = "X-Page"
  
  /// The number of the next page
  case nextPage = "X-Next-Page"
  
  /// The number of the previous page
  case prevPage = "X-Prev-Page"
  
  /// Private Token
  case privateToken = "Private-Token"
  
  /// OAuth Token
  case oAuthToken = "Authorization"
}

/// HTTP Methods
public enum HTTPMethod: String {
  /// Get
  case get = "GET"
  
  /// Post
  case post = "POST"
  
  /// Put
  case put = "PUT"
  
  /// Delete
  case delete = "DELETE"
  
  /// Update
  case update = "UPDATE"
  
  /// Patch
  case patch = "PATCH"
  
  /// Head
  case head = "HEAD"

}

/// HTTP Errors
public enum HTTPError: Error {
  /// Bad Request - 400
  case badRequest(message: String?)
  
  /// Unauthorized Access - 401
  case unauthorized(message: String?)
  
  /// Forbidden Access - 403
  case forbidden(message: String?)
  
  /// Requested resource could not be found - 404
  case notFound(message: String?)
  
  /// A request method is not supported - 405
  case methodNotAllowed(message: String?)
  
  /// Server failed to fulfill a request - 5xx
  case serverFailure(message: String?)
  
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
  /// A localized error description
  public var errorDescription: String? {
    switch self {
    case .badRequest(let message):
      return NSLocalizedString("Bad Request: \(message ?? "")", comment: "Bad Request") // 400
    case .unauthorized(let message):
      return NSLocalizedString("Unauthorized: \(message ?? "")", comment: "Unauthorized") // 401
    case .forbidden(let message):
      return NSLocalizedString("Forbidden: \(message ?? "")", comment: "Forbidden") // 403
    case .notFound(let message):
      return NSLocalizedString("Not Found: \(message ?? "")", comment: "Not Found") // 404
    case .methodNotAllowed(let message):
      return NSLocalizedString("Method Not Allowed: \(message ?? "")", comment: "Method Not Allowed") // 405
    case .serverFailure(let message):
      return NSLocalizedString("Server Failure: \(message ?? "")", comment: "Server failure") // 5xx
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

/// This protocol is used to enable creating URLSession mocks
public protocol URLSessionProtocol {
  typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
  /**
   * data task convenience methods.  These methods create tasks that
   * bypass the normal delegate calls for response and data delivery,
   * and provide a simple cancelable asynchronous interface to receiving
   * data.  Errors will be returned in the NSURLErrorDomain,
   * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
   * called for authentication challenges.
   */
  func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

/// This protocol is used to enable creating URLSessionDataTask mocks
public protocol URLSessionDataTaskProtocol {
  func resume()
  func cancel()
}

// MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
  /**
   * data task convenience methods.  These methods create tasks that
   * bypass the normal delegate calls for response and data delivery,
   * and provide a simple cancelable asynchronous interface to receiving
   * data.  Errors will be returned in the NSURLErrorDomain,
   * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
   * called for authentication challenges.
   */
  public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
