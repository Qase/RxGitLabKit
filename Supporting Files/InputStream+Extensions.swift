//
//  InputStream+Extensions.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 21/08/2018.
//

import Foundation

extension InputStream {

  public func readData(bufferSize: Int = 4096) -> Data {
    var result = Data()
    var buffer = [UInt8](repeating: 0, count: bufferSize)
    var bytesRead = 0
    open()
    while hasBytesAvailable {
      bytesRead = read(&buffer, maxLength: bufferSize)
      result.append(buffer, count: bytesRead)
    }
    close()
    return result
  }

  public func readString(bufferSize: Int = 4096) -> String {
    let data = readData(bufferSize: bufferSize)
    return String(data: data, encoding: .utf8) ?? ""
  }
}
