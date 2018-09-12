//
//  ATPManager.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import Renderer

public protocol ATPManager {
  func initSDK(atpConfig: ATPConfig)

  func register(nasAddress: String, completion: @escaping (TIE?) -> Void) throws

  func getTIE() -> TIE?

  func parseTIE(tie: TIE) throws -> ADForm?

  func dispatch(adForm: ADForm?) -> ATPRenderer?

  func delegateInteract(atpEvent: ATPEvent, completion: @escaping (String?) -> Void) throws
}
