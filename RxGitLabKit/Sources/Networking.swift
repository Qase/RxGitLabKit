//
//  APIRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

public typealias QueryParameters = [String: String]
public typealias JSONDictionary = [String: Any]
public typealias Header = [String : String]

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
  case update = "UPDATE"
  case patch = "PATCH"
  case head = "HEAD"
}

public enum NetworkingError: Error {
  case badRequest // 400
  case unauthorized // 401
  case forbidden // 403
  case notFound // 404
  case methodNotAllowed // 405
  case serverFailure // 5xx
  case unspecified(Int)
  case parsingJSONFailure
  case invalidRequest(message: String?)
}

public protocol APIRequesting {
  var method: HTTPMethod { get }
  var path: String? { get }
  var parameters: QueryParameters? { get }
  var jsonDictionary: JSONDictionary? {get}
}

extension APIRequesting {
  func buildRequest(with hostURL: URL, header: Header?) -> URLRequest? {
    var pathURL = hostURL
    if let path = path {
      pathURL.appendPathComponent(path)
    }
    
    guard var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: false) else { return nil }
    
    if let parameters = parameters {
      components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    }
    guard let url = components.url else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = header
    if let jsonBody = jsonDictionary, let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) {
      request.httpBody = jsonData
    }
    
    return request
  }
}

struct APIRequest: APIRequesting {
  var method: HTTPMethod
  var path: String?
  var parameters: QueryParameters?
  var jsonDictionary: JSONDictionary?
  
  init(path: String = "", method: HTTPMethod = HTTPMethod.get, parameters: QueryParameters? = nil, jsonBody: JSONDictionary? = nil) {
    self.path = path
    self.method = method
    self.parameters = parameters
    self.jsonDictionary = jsonBody
  }
}

protocol Networking {
  static func response(for request: URLRequest,in session: URLSession) -> Observable<(response: HTTPURLResponse, data: Data)>
  static func object<T: Codable>(for request: URLRequest,in session: URLSession) -> Observable<T>
  static func data(for request: URLRequest,in session: URLSession) -> Observable<Data>
  static func json(for request: URLRequest,in session: URLSession) -> Observable<JSONDictionary>
  
  func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
  func object<T: Codable>(for request: URLRequest) -> Observable<T>
  func data(for request: URLRequest) -> Observable<Data>
  func json(for request: URLRequest) -> Observable<JSONDictionary>
}

class Network: Networking {

  let session: URLSession
  
  init(with session: URLSession) {
    self.session = session
  }
  
  // přejmenovat na response(for request: URLRequest, in session: URLSession)
  static func response(for request: URLRequest,in session: URLSession) -> Observable<(response: HTTPURLResponse, data: Data)> {
    return session.rx.response(request: request)
  }
  
  static func data(for request: URLRequest,in session: URLSession) -> Observable<Data> {
    return self.response(for: request, in: session)
      .flatMap { (response, data) -> Observable<Data> in
        Observable.create { observer in
          switch response.statusCode {
          case 200..<300:
            observer.onNext(data)
            observer.onCompleted()
          case 400:
            observer.onError(NetworkingError.badRequest)
          case 401:
            observer.onError(NetworkingError.unauthorized)
          case 403:
            observer.onError(NetworkingError.forbidden)
          case 404:
            observer.onError(NetworkingError.notFound)
          case 500..<600:
            observer.onError(NetworkingError.serverFailure)
          default:
            observer.onError(NetworkingError.unspecified(response.statusCode))
          }
          return Disposables.create()
        }
      }
  }
  
  static func object<T>(for request: URLRequest,in session: URLSession) -> Observable<T> where T : Decodable, T : Encodable {
    return self.data(for: request, in: session)
      .flatMap { data -> Observable<T> in
        return Observable.create{ observer in
          let decoder = JSONDecoder.init()
          if let object = try? decoder.decode(T.self, from: data) {
            observer.onNext(object)
            observer.onCompleted()
          } else {
            observer.onError(NetworkingError.parsingJSONFailure)
          }
          
          return Disposables.create()
        }
      }
  }
  
  static func json(for request: URLRequest, in session: URLSession) -> Observable<JSONDictionary> {
    return self.data(for: request, in: session)
      .flatMap { data -> Observable<JSONDictionary> in
        return Observable.create { observer in
          if let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary,
            let jsonDictionary = dictionary {
            observer.onNext(jsonDictionary)
            observer.onCompleted()
          } else {
            observer.onError(NetworkingError.parsingJSONFailure)
          }
          return Disposables.create()
        }
    }
  }
  
  func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
    return Network.response(for: request, in: session)
  }
  
  func data(for request: URLRequest) -> Observable<Data> {
    return Network.data(for:request, in: session)
  }
  
  func object<T>(for request: URLRequest) -> Observable<T> where T : Decodable, T : Encodable {
    return Network.object(for: request, in: session)
  }
  
  func json(for request: URLRequest) -> Observable<JSONDictionary> {
    return Network.json(for: request, in: session)
  }
}
