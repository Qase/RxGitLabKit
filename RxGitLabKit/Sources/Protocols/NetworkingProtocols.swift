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
  case parsingJSONFailure
  
  /// An invalid request
  case invalidRequest(message: String?)
  
  case nonHTTPResponse(response: URLResponse)
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
    case .parsingJSONFailure:
      return NSLocalizedString("Parsing JSON Failure", comment: "Parsing JSON Failure")
    case .invalidRequest(let message):
      return NSLocalizedString("Invalid Request: \(message ?? "")", comment: "Invalid Request: \(message ?? "")")
    case .nonHTTPResponse(let response):
      return NSLocalizedString("Non HTTP Response from URL: \(response.url).", comment: "Non HTTP Response from URL: \(response.url).")
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
  public func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
    return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

public protocol Networking {
  func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
  func header(for request: URLRequest) -> Observable<Header>
  
  func object<T: Codable>(for request: URLRequest) -> Observable<T>
  func data(for request: URLRequest) -> Observable<Data>
  func json(for request: URLRequest) -> Observable<JSONDictionary>
}
