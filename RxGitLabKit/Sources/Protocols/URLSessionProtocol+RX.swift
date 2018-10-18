//
//  URLSessionProtocol+RX.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 18/10/2018.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSessionProtocol {
  /**
   Observable sequence of responses for URL request.
   
   Performing of request starts after observer is subscribed and not after invoking this method.
   
   **URL requests will be performed per subscribed observer.**
   
   Any error during fetching of the response will cause observed sequence to terminate with error.
   
   - parameter request: URL request.
   - returns: Observable sequence of URL responses.
   */
  public func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
    return Observable.create { observer in
      
      let task = self.base.dataTask(with: request) { (data, response, error) in

        guard let response = response, let data = data else {
          observer.on(.error(error ?? RxCocoaURLError.unknown))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
          observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
          return
        }
        
        observer.on(.next((httpResponse, data)))
        observer.on(.completed)
      }
      
      task.resume()
      
      
      return Disposables.create(with: task.cancel)
    }
  }
  
  /**
   Observable sequence of response data for URL request.
   
   Performing of request starts after observer is subscribed and not after invoking this method.
   
   **URL requests will be performed per subscribed observer.**
   
   Any error during fetching of the response will cause observed sequence to terminate with error.
   
   If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
   will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
   
   - parameter request: URL request.
   - returns: Observable sequence of response data.
   */
  public func data(request: URLRequest) -> Observable<Data> {
    return response(request: request).map { (response, data) -> Data in
      if 200 ..< 300 ~= response.statusCode {
        return data
      }
      else {
        throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
      }
    }
  }
  
  /**
   Observable sequence of response JSON for URL request.
   
   Performing of request starts after observer is subscribed and not after invoking this method.
   
   **URL requests will be performed per subscribed observer.**
   
   Any error during fetching of the response will cause observed sequence to terminate with error.
   
   If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
   will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
   
   If there is an error during JSON deserialization observable sequence will fail with that error.
   
   - parameter request: URL request.
   - returns: Observable sequence of response JSON.
   */
  public func json(request: URLRequest, options: JSONSerialization.ReadingOptions = []) -> Observable<Any> {
    return data(request: request).map { (data) -> Any in
      do {
        return try JSONSerialization.jsonObject(with: data, options: options)
      } catch let error {
        throw RxCocoaURLError.deserializationError(error: error)
      }
    }
  }
  
  /**
   Observable sequence of response JSON for GET request with `URL`.
   
   Performing of request starts after observer is subscribed and not after invoking this method.
   
   **URL requests will be performed per subscribed observer.**
   
   Any error during fetching of the response will cause observed sequence to terminate with error.
   
   If response is not HTTP response with status code in the range of `200 ..< 300`, sequence
   will terminate with `(RxCocoaErrorDomain, RxCocoaError.NetworkError)`.
   
   If there is an error during JSON deserialization observable sequence will fail with that error.
   
   - parameter url: URL of `NSURLRequest` request.
   - returns: Observable sequence of response JSON.
   */
  public func json(url: Foundation.URL) -> Observable<Any> {
    return json(request: URLRequest(url: url))
  }
}
