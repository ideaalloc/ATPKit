//
//  Connectivity.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
  class var isConnectedToInternet: Bool {
    return NetworkReachabilityManager()!.isReachable
  }
}
