//
//  APIRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift
import RxCocoa

typealias QueryParameters = [String: String]
typealias JSONDictionary = [String: Any]
typealias Header = [String : String]

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case update = "UPDATE"
  case delete = "DELETE"
  case patch = "PATCH"
  case head = "HEAD"
}

public enum NetworkingError: Error {
  case badRequest // 400
  case unauthorized // 401
  case forbidden // 403
  case notFound // 404
  case serverFailure // 5xx
  case unspecified(Int)
  case parsingJSONFailure
  case invalidRequest
}

protocol APIRequesting {
  var method: HTTPMethod { get }
  var path: String? { get }
  var parameters: QueryParameters? { get }
  var jsonDictionary: JSONDictionary? {get}
}

extension APIRequesting {
  func buildRequest(with baseURL: URL) -> URLRequest? {
    var pathURL = baseURL
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
    request.addValue("application/json", forHTTPHeaderField: "Accept")
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
  var baseURL: URL { get set }
  func request(request: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data)>
  func object<T: Codable>(request: APIRequesting) -> Observable<T>
  func data(request: APIRequesting) -> Observable<Data>
  func json(request: APIRequesting) -> Observable<JSONDictionary>
}

class Network: Networking {
  
  internal var baseURL: URL
  
  init(host: URL) {
    baseURL = host
  }
  
  func request(request: APIRequesting) -> Observable<(response: HTTPURLResponse, data: Data)> {
    guard let request = request.buildRequest(with: self.baseURL) else { return Observable.error(NetworkingError.invalidRequest) }
    return URLSession.shared.rx.response(request: request)
  }
  
  
  func data(request: APIRequesting) -> Observable<Data> {
    return self.request(request: request)
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
  
  func object<T>(request: APIRequesting) -> Observable<T> where T : Decodable, T : Encodable {
    return self.data(request: request)
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
  
  func json(request: APIRequesting) -> Observable<JSONDictionary> {
    return self.data(request: request)
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
  
}


