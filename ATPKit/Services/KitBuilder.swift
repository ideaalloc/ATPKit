//
//  KitBuilder.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import Renderer

public class KitBuilder {
  private var type: String
  private var atpManager: ATPManager?

  public init(type: String) {
    self.type = type
    if type == TIEType.voting.rawValue {
      atpManager = VotingManager()
    } else {
      atpManager = VotingManager()
    }
  }

  public func initSDK(atpConfig: ATPConfig) {
    atpManager?.initSDK(atpConfig: atpConfig)
  }

  public func register(nasAddress: String, completion: @escaping (TIE?) -> Void) throws {
    try atpManager?.register(nasAddress: nasAddress, completion: completion)
  }

  public func getTIE() -> TIE? {
    return atpManager?.getTIE()
  }

  public func parseTIE(tie: TIE) throws -> ADForm? {
    return try (atpManager?.parseTIE(tie: tie))
  }

  public func dispatch(adForm: ADForm?) -> ATPRenderer? {
    return atpManager?.dispatch(adForm: adForm)
  }

  public func delegateInteract(atpEvent: ATPEvent, completion: @escaping (String?) -> Void) throws {
    try atpManager?.delegateInteract(atpEvent: atpEvent, completion: completion)
  }

}
