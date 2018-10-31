//
//  Enpoint.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 06/08/2018.
//

import Foundation
import RxSwift

public class EndpointGroup: HostCommunicator {
  
  public let perPage = Variable<Int>(100)
    
  public enum Enpoints {}
  
  public required override init(network: Networking, hostURL: URL) {
    super.init(network: network, hostURL: hostURL)
  }
}
