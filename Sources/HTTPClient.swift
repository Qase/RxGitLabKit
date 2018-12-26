//
//  APIRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift


/// Basic networking protocol
public protocol Networking {
  func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data?)>
  func header(for request: URLRequest) -> Observable<Header>
  func object<T: Codable>(for request: URLRequest) -> Observable<T>
  func data(for request: URLRequest) -> Observable<Data>
  func json(for request: URLRequest) -> Observable<JSONDictionary>
}

/// Implementation of the `Networking` protocol
public class HTTPClient: Networking {
  
  /// URLSession that can be mocked
  private let session: URLSessionProtocol
  
  public init(using session: URLSessionProtocol) {
    self.session = session
  }
  
  /// Sends a request to the server and the response can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  ///   - session: session used for communication
  /// - Returns: An Observable of the `HTTPURLResponse` and `Data` if there is any
  public static func response(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return Observable.create { observer in
      let task = session.dataTask(with: request) { (data, response, error) in
        guard let response = response else {
          observer.on(.error(error ?? HTTPError.noResponse))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          observer.on(.error(HTTPError.nonHTTPResponse(response: response)))
          return
        }
        
        observer.on(.next((httpResponse, data)))
        observer.on(.completed)
      }
      
      task.resume()
      return Disposables.create(with: task.cancel)
    }.debug()
  }
  
  /// Sends a request to the server and the response header can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  ///   - session: session used for communication
  /// - Returns: An Observable of the `Header`
  public static func header(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<Header> {
    return HTTPClient.response(for: request, in: session)
      .flatMap { (response, data) -> Observable<Header> in
        let errorMessage = (data != nil) ? String(data: data!, encoding: .utf8) : nil
        return Observable.create { observer in
          switch response.statusCode {
          case 200..<300:
            observer.onNext(response.allHeaderFields as! Header)
            observer.onCompleted()
          case 400:
            observer.onError(HTTPError.badRequest(message: errorMessage))
          case 401:
            observer.onError(HTTPError.unauthorized(message: errorMessage))
          case 403:
            observer.onError(HTTPError.forbidden(message: errorMessage))
          case 404:
            observer.onError(HTTPError.notFound(message: errorMessage))
          case 500..<600:
            observer.onError(HTTPError.serverFailure(message: errorMessage))
          default:
            observer.onError(HTTPError.unknown(response.statusCode))
          }
          return Disposables.create()
        }
    }
  }
  
  /// Sends a request to the server and the response data can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  ///   - session: session used for communication
  /// - Returns: An Observable of the `Data` if there is any
  public static func data(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<Data> {
    return HTTPClient.response(for: request, in: session)
      .flatMap { (response, data) -> Observable<Data> in
        Observable.create { observer in
          guard let data = data, let errorMessage = String(data: data, encoding: .utf8)
            else {
              observer.onError(HTTPError.noData)
              return Disposables.create()
          }
          switch response.statusCode {
          case 200..<300:
            observer.onNext(data)
            observer.onCompleted()
          case 400:
            observer.onError(HTTPError.badRequest(message: errorMessage))
          case 401:
            observer.onError(HTTPError.unauthorized(message: errorMessage))
          case 403:
            observer.onError(HTTPError.forbidden(message: errorMessage))
          case 404:
            observer.onError(HTTPError.notFound(message: errorMessage))
          case 500..<600:
            observer.onError(HTTPError.serverFailure(message: errorMessage))
          default:
            observer.onError(HTTPError.unknown(response.statusCode))
          }
          return Disposables.create()
        }
    }
  }
  
  
  /// Sends a request to the server and the response data are transformed into object of type `T` and it can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  ///   - session: session used for communication
  /// - Returns: An Observable of `T`
  public static func object<T>(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<T> where T: Decodable, T: Encodable {
    return HTTPClient.data(for: request, in: session)
      .flatMap { data -> Observable<T> in
        return Observable.create { observer in
          do {
            let decoder = JSONDecoder.init()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601full)
            let object = try decoder.decode(T.self, from: data)
            observer.onNext(object)
            observer.onCompleted()
          } catch let error {
            print(String(data: data, encoding: .utf8)!)
            observer.onError(HTTPError.parsingJSONFailure(error: error))
          }
          
          return Disposables.create()
        }
    }
  }
  
  /// Sends a request to the server and the response data in JSON format can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  ///   - session: session used for communication
  /// - Returns: An Observable of the `JSONDictionary`
  public static func json(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<JSONDictionary> {
    return self.data(for: request, in: session)
      .flatMap { data -> Observable<JSONDictionary> in
        return Observable.create { observer in
          do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDictionary
            observer.onNext(dictionary)
            observer.onCompleted()
          } catch let error {
            observer.onError(HTTPError.parsingJSONFailure(error: error))
          }
          return Disposables.create()
        }
    }
  }
  
  /// Sends a request to the server and the response can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  /// - Returns: An Observable of the `HTTPURLResponse` and `Data` if there is any
  public func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return HTTPClient.response(for: request, in: session)
  }
  
  /// Sends a request to the server and the response header can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  /// - Returns: An Observable of the `Header`
  public func header(for request: URLRequest) -> Observable<Header> {
    return HTTPClient.header(for: request, in: session)
  }
  
  /// Sends a request to the server and the response data can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  /// - Returns: An Observable of the `Data` if there is any
  public func data(for request: URLRequest) -> Observable<Data> {
    return HTTPClient.data(for: request, in: session)
  }
  
  /// Sends a request to the server and the response data are transformed into object of type `T` and it can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  /// - Returns: An Observable of `T`
  public func object<T>(for request: URLRequest) -> Observable<T> where T: Decodable, T: Encodable {
    return HTTPClient.object(for: request, in: session)
  }
  
  /// Sends a request to the server and the response data in JSON format can be subscribed to
  ///
  /// - Parameters:
  ///   - request: request sent to server
  /// - Returns: An Observable of the `JSONDictionary`
  public func json(for request: URLRequest) -> Observable<JSONDictionary> {
    return HTTPClient.json(for: request, in: session)
  }
}
