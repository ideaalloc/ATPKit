//
//  KitFactory.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public class KitFactory: NSObject {
  public static let sharedInstance = KitFactory()
  private static let setup = KitFactoryHolder()

  public class func setup(type: String) {
    KitFactory.setup.type = type
  }

  fileprivate override init() {
    let type = KitFactory.setup.type
    guard type != nil else {
      fatalError("Error - you must call setup before accessing KitFactory.sharedInstance")
    }
    kitBuilder = KitBuilder(type: type!)
    super.init()
  }

  fileprivate var kitBuilder: KitBuilder

  public func getKitBuilder() -> KitBuilder {
    return kitBuilder
  }
}

private class KitFactoryHolder {
  var type: String?
}
