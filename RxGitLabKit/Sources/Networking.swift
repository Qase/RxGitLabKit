//
//  APIRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift

typealias QueryParameters = [String: String]
typealias Header = [String : String]

public enum RequestMethod: String {
  case get, post, put, update, delete, patch
}

protocol APIRequest {
  var method: RequestMethod { get }
  var path: String { get }
  var parameters: QueryParameters { get }
}

extension APIRequest {
  func buildRequest(with baseURL: URL) -> URLRequest {
    var pathURL = baseURL
    pathURL.appendPathComponent(path)
    
    guard var components = URLComponents(url: pathURL, resolvingAgainstBaseURL: false) else { fatalError("Unable to create URL Components") }
    
    components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    
    guard let url = components.url else { fatalError("Could not create URL") }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    return request
  }
}

protocol APIResponse {
  var method: RequestMethod { get }
  var path: String { get }
  var parameters: QueryParameters { get }
}



protocol Networking {
  var baseURL: URL { get set }
  func request<T: Codable>(apiRequest: APIRequest) -> Observable<T>
}


class Network: Networking {
  internal var baseURL: URL
  
  init(host: URL) {
    baseURL = host
  }
  
  func request<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
    return Observable<T>.create { observer in
      let request = apiRequest.buildRequest(with: self.baseURL)
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        do {
          let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
          observer.onNext(model)
        } catch let err {
          observer.onError(err)
        }
        observer.onCompleted()
      }
      task.resume()
      return Disposables.create {
        task.cancel()
      }
    }
  }
}


