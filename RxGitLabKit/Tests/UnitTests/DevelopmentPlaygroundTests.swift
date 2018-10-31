//
//  RxGitLabAPIClientTests.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation
import XCTest
import RxGitLabKit
import RxSwift
import RxTest
import RxBlocking

class DevelopmentPlaygroundTests: XCTestCase {
  
 
  private var client: RxGitLabAPIClient!
  
  private let hostURL = URL(string: "https://gitlab.fel.cvut.cz")!
  
  private let bag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    //    URLProtocol.registerClass(MockURLProtocol.self)
    client = RxGitLabAPIClient(with: hostURL)
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testAuthentication2() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
      
    
    let bag = DisposeBag()
    
    let username = "tranaduc"
    let password = "nV4-ubr-M8V-LFx"
    
    //    XCTAssert(client.test == "tesst")
    
    let authentication = client.authentication.authenticate(username: username, password: password)
    let expectation = XCTestExpectation(description: "response")
    authentication.subscribe { event in
      print(event)
      expectation.fulfill()
      }.disposed(by: bag)
    wait(for: [expectation], timeout: 1)
  }
  
  func testDate() {
    let calendar = Calendar(identifier: .gregorian)
    let timeZone = TimeZone(secondsFromGMT: -3*3600)
    let components = DateComponents(calendar: calendar, timeZone: timeZone, year: 2012, month: 9, day: 20, hour: 9, minute: 6, second: 12)
    let date = calendar.date(from: components)!
//    let date2 = calendar.date(from: components)!
//    print(date == date2)
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date1 = dateFormatter.date(from: "2012-09-20T09:06:12-03:00")!
    let date2 = dateFormatter.date(from: "2012-09-20T09:06:12-03:00")!
    print(date1 == date2)
    print(date.compare(date2).rawValue)
    
  }
  
  func testQueryParams() {
    let now = Date()
    
//    print(dict["date"])
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    print(formatter.string(from: now))
    
    
    print(formatter.date(from: "2015-04-07T22:28:38.000Z"))
    
    let dict: [String : Any] = [
      "string" : "username",
      "int": 1,
      "float": 1.1,
      "array": [1, 2],
      "stats" : true,
      "date" : formatter.string(from: now),
    ]
    
    let queryItems = dict.map { (key, value) -> URLQueryItem in
      switch value {
      case let bool as Bool:
        return URLQueryItem(name: key, value: bool ? "true" : "false")
      case let date as Date:
        return URLQueryItem(name: key, value: formatter.string(from: date))
      case is Array<Any>:
        return URLQueryItem(name: key, value: (value as! Array<Any>).map { "\($0)"}.joined(separator: ","))
      default:
        return URLQueryItem(name: key, value: "\(value)")
      }
    }
    
    var url = URLComponents(string: "https://testhost.cz")!
    url.queryItems = queryItems
    
    let request = url.url!
    
    print(request)
    
//    if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
//      print(String(data: data, encoding: .utf8)!)
//    } else {
//      print("Encoding not successful")
//    }
    
    
  }
  
  func testFilter() {
    let scheduler = TestScheduler(initialClock: 0)
    var subscription: Disposable!
    // 1
    let observer = scheduler.createObserver(Int.self)
    
    // 2
    let observable = scheduler.createHotObservable([
      next(100, 1),
      next(200, 2),
      next(300, 3),
      next(400, 2),
      next(500, 1)
      ])
    
    // 3
    let filterObservable = observable.filter {
      $0 < 3
    }
    
    // 4
    scheduler.scheduleAt(0) {
      subscription = filterObservable.subscribe(observer)
    }
    
    // 5
    scheduler.start()
    
    // 6
    let results = observer.events.map { (event) -> Int in
      let number: Int = event.value.element!
      print(number)
      return number
    }
    
    // 7
    XCTAssertEqual(results, [1, 2, 2, 1])
    
    scheduler.scheduleAt(1000) {
      subscription.dispose()
    }
  }
  
  func testToArray() {
    
    // 1
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    // 2
    let toArrayObservable = Observable.of(1, 2).subscribeOn(scheduler)
    
    let a = try! toArrayObservable.toBlocking()
    // 3
    XCTAssertEqual(try! toArrayObservable.toBlocking().toArray(), [1, 2])
  }
  
  
  func testDecode() {
    
    let json = CommitsMocks.commitJSONs[38]
    print(json)
    let decoder = JSONDecoder()
    do {
      let commit = try decoder.decode(Commit.self, from: json.data())
      print(commit)
    } catch (let error) {
      XCTFail(error.localizedDescription)
    }
    var i = 0
//    do {
//      let commits: [Commit] = try CommitsMocks.commitJSONs.map { json in
//        let decoder = JSONDecoder()
//        print(i)
//        i+=1
//        return try decoder.decode(Commit.self, from: json.data())
//      }
//    } catch (let error) {
//      XCTFail(error.localizedDescription)
//    }
  }
}
