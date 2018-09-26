//
//  LibraryAPI.swift
//  ATPKit
//
//  Created by Bill Lv on 8/22/18.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import UIKit
import Renderer

public class LibraryAPI: NSObject {
  // MARK: - Singleton Pattern
  public static let sharedInstance = LibraryAPI()
  private static let setup = LibraryAPIHolder()

  public class func setup(baseEP: String) {
    LibraryAPI.setup.baseEP = baseEP
  }

  // MARK: - Variables
  fileprivate var httpClient: HTTPClient

  fileprivate override init() {
    let baseEP = LibraryAPI.setup.baseEP
    guard baseEP != nil else {
      fatalError("Error - you must call setup before accessing LibraryAPI.sharedInstance")
    }

    httpClient = HTTPClient(baseEP: baseEP!)
    super.init()
  }

  // MARK: - Public API

  public func getTIE(_ nasAddr: String, _ contractAddr: String, _ campaignID: String
      , completion: @escaping (String?) -> Void) throws {
    try httpClient.getRequest("/tie?nasAddr=\(nasAddr)&contractAddr=\(contractAddr)&campaignID=\(campaignID)"
        , completion: completion)
  }

  public func vote(_ vote: Vote, completion: @escaping (String?) -> Void) throws {
    if let jsonData = try? JSONEncoder().encode(vote) {
      let jsonString = String(data: jsonData, encoding: .utf8)
      try httpClient.postRequest("/interact", body: jsonString, completion: completion)
    }
  }

  public func register(_ account: Account, completion: @escaping (String?) -> Void) throws {
    if let jsonData = try? JSONEncoder().encode(account) {
      let jsonString = String(data: jsonData, encoding: .utf8)
      try httpClient.postRequest("/sae/signup", body: jsonString, completion: completion)
    }
  }

}

private class LibraryAPIHolder {
  var baseEP: String?
}
