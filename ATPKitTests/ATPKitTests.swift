//
//  ATPKitTests.swift
//  ATPKitTests
//
//  Created by Bill Lv on 2018/8/30.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import XCTest
import Renderer
@testable import ATPKit

class ATPKitTests: XCTestCase {
  let baseEP = "http://test-ces.atpsrv.net/v1"
  let campaignID = "cbe56uvvif2m9fc3hn0og"

  private var kitBuilder: KitBuilder?

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    KitFactory.setup(type: TIEType.voting.rawValue)
    kitBuilder = KitFactory.sharedInstance.getKitBuilder()
    kitBuilder?.initSDK(atpConfig: ATPConfig(baseEP: baseEP, campaignID: campaignID))
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testKitBuilder() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let nasAddress = "n1NJP2yD5eHrWFDzydGbXXhxPXAjZvxdJJR"
    try kitBuilder?.register(nasAddress: nasAddress, completion: { tie in
      let voteData: VoteData = self.kitBuilder?.parseTIE(tie: tie!) as! VoteData
      XCTAssertNotNil(voteData)
    })
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
