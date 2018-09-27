//
//  ATPConfig.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public struct ATPConfig: Codable {
  let baseEP: String
  let campaignID: String
  let lang: String
  let accid: String?
  let msg: String?

  public init(baseEP: String, campaignID: String, lang: String = "en", accid: String? = nil, msg: String? = nil) {
    self.baseEP = baseEP
    self.campaignID = campaignID
    self.lang = lang
    self.accid = accid
    self.msg = msg
  }
}