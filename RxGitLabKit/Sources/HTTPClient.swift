//
//  APIRequest.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/08/2018.
//

import Foundation
import RxSwift

public protocol Networking {
  func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data?)>
  func header(for request: URLRequest) -> Observable<Header>

  func object<T: Codable>(for request: URLRequest) -> Observable<T>
  func data(for request: URLRequest) -> Observable<Data>
  func json(for request: URLRequest) -> Observable<JSONDictionary>
}

public class HTTPClient: Networking {

  private let session: URLSessionProtocol

  public init(using session: URLSessionProtocol) {
    self.session = session
  }

  public static func response(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    print("Request")
    debugPrint(request)
    if let body = request.httpBody {
      debugPrint(String(data: body, encoding: .utf8)!)
    }
    if let headers = request.allHTTPHeaderFields, headers.count > 0 {
      debugPrint(headers)
    }
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
    }
  }

  public static func header(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<Header> {
    return HTTPClient.response(for: request, in: session)
      .flatMap { (response, _) -> Observable<Header> in

        Observable.create { observer in
          switch response.statusCode {
          case 200..<300:
            observer.onNext(response.allHeaderFields as! Header)
            observer.onCompleted()
          case 400:
            observer.onError(HTTPError.badRequest)
          case 401:
            observer.onError(HTTPError.unauthorized)
          case 403:
            observer.onError(HTTPError.forbidden)
          case 404:
            observer.onError(HTTPError.notFound)
          case 500..<600:
            observer.onError(HTTPError.serverFailure)
          default:
            observer.onError(HTTPError.unknown(response.statusCode))
          }
          return Disposables.create()
        }
    }
  }

  public static func data(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<Data> {
    return HTTPClient.response(for: request, in: session)
      .flatMap { (response, data) -> Observable<Data> in
        Observable.create { observer in
          guard let data = data else {
            observer.onError(HTTPError.noData)
            return Disposables.create()
          }
          switch response.statusCode {
          case 200..<300:
            observer.onNext(data)
            observer.onCompleted()
          case 400:
            observer.onError(HTTPError.badRequest)
          case 401:
            observer.onError(HTTPError.unauthorized)
          case 403:
            observer.onError(HTTPError.forbidden)
          case 404:
            observer.onError(HTTPError.notFound)
          case 500..<600:
            observer.onError(HTTPError.serverFailure)
          default:
            observer.onError(HTTPError.unknown(response.statusCode))
          }
          return Disposables.create()
        }
    }
  }

  public static func object<T>(for request: URLRequest, in session: URLSessionProtocol = URLSession.shared) -> Observable<T> where T: Decodable, T: Encodable {
    return HTTPClient.data(for: request, in: session)
      .flatMap { data -> Observable<T> in
        return Observable.create { observer in
          do {
            let decoder = JSONDecoder.init()
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

  public func response(for request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data?)> {
    return HTTPClient.response(for: request, in: session)
  }

  public func header(for request: URLRequest) -> Observable<Header> {
    return HTTPClient.header(for: request, in: session)
  }

  public func data(for request: URLRequest) -> Observable<Data> {
    return HTTPClient.data(for: request, in: session)
  }

  public func object<T>(for request: URLRequest) -> Observable<T> where T: Decodable, T: Encodable {
    return HTTPClient.object(for: request, in: session)
  }

  public func json(for request: URLRequest) -> Observable<JSONDictionary> {
    return HTTPClient.json(for: request, in: session)
  }
}
