//
//  VotingManager.swift
//  ATPKit
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation
import Renderer

public class VotingManager: ATPManager {
  fileprivate var atpConfig: ATPConfig?
  fileprivate var nasAddress: String?
  fileprivate var contractAddress: String?
  fileprivate var tie: TIE?

  public func initSDK(atpConfig: ATPConfig) {
    self.atpConfig = atpConfig
    LibraryAPI.setup(baseEP: atpConfig.baseEP)
  }

  public func register(nasAddress: String, completion: @escaping (TIE?) -> Void) throws {
    let campaignID = (atpConfig?.campaignID)!
    try LibraryAPI.sharedInstance.register(Account(nasAddress: nasAddress, campaignID: campaignID)
        , completion: { responseString in
      let data = responseString?.data(using: .utf8)
      if let respData = data,
         let decodedResp = try? JSONSerialization.jsonObject(with: respData) as! [String: Any] {
        print(decodedResp["success"] as! Bool)
        if decodedResp["success"] as! Bool {
          self.nasAddress = nasAddress
          let data = decodedResp["data"] as! [String: Any]
          let contractAddress = data["contract"] as! String
          debugPrint("contract address", contractAddress)
          self.contractAddress = contractAddress
          try! LibraryAPI.sharedInstance.getTIE(nasAddress, contractAddress, campaignID, completion: { rs in
            let dt = rs?.data(using: .utf8)
            if let decResp = try? JSONSerialization.jsonObject(with: dt!) as! [String: Any] {
              print(decResp["success"] as! Bool)
              if decResp["success"] as! Bool {
                let secondLayer = decResp["data"] as! [String: Any]
                let state = secondLayer["state"] as! String
                if state == "END" {
                  self.tie = TIE(type: .error, raw: ErrorMsg.end)
                  completion(self.tie)
                } else {
                  self.tie = TIE(type: .voting, raw: secondLayer["data"] as! String)
                  completion(self.tie)
                }
              } else {
                let errorMsg = decResp["errorMsg"] as! String
                self.tie = TIE(type: .error, raw: errorMsg)
                completion(self.tie)
              }
            }
          })
        } else {
          let errorMsg = decodedResp["errorMsg"] as! String
          self.tie = TIE(type: .error, raw: errorMsg)
          completion(self.tie)
        }
      } else {
        self.tie = nil
        completion(self.tie)
      }
    })
  }

  public func getTIE() -> TIE? {
    return tie
  }

  public func parseTIE(tie: TIE) throws -> ADForm? {
    let dataEnc = tie.raw
    let dataDecodedString = String(data: Data(base64Encoded: dataEnc)!, encoding: .utf8)!.replacingOccurrences(of: "\\", with: "")
    debugPrint("data decoded string", dataDecodedString)
    if let firstLayerJson = try? JSONSerialization.jsonObject(with: dataDecodedString.data(using: .utf8)!) as! NSArray {
      debugPrint("firstLayerJson", firstLayerJson)
      let lang = getLang(lang: atpConfig?.lang, defaultLang: "en")
      var objs = firstLayerJson.filter{($0 as! [String: Any])["language"] as! String == lang}
      if lang == "en" {
        if objs.count == 0 {
          return nil
        }
      } else {
        objs = firstLayerJson.filter{($0 as! [String: Any])["language"] as! String == "en"}
        if objs.count == 0 {
          return nil
        }
      }

      let secondLayerJson = objs[0] as! [String: Any]
      debugPrint("obj", secondLayerJson)
      let question = secondLayerJson["question"] as! String
      let options = secondLayerJson["options"] as! NSArray
      let optionsText = secondLayerJson["optionsText"] as! NSArray
      let message = secondLayerJson["message"] as! String
      debugPrint("question", question)
      debugPrint("options", options)
      debugPrint("message", message)
      var opts: Array<String> = Array()
      for (index, element) in options.enumerated() {
        let va = valArray(arr: optionsText, index: index)
        let v = val(value: va, defaultValue: element as! String)
        opts.append(v)
      }
      let msg = val(value: atpConfig?.msg, defaultValue: message)
      return VoteData(question: question, options: opts, message: msg)
    }
    return nil
  }

  private func getLang(lang: String?, defaultLang: String) -> String {
    guard let vlang = lang else {
      return defaultLang
    }
    return vlang
  }

  private func valArray(arr: NSArray, index: Int) -> String? {
    if arr.count - 1 < index {
      return nil
    }
    return arr[index] as? String
  }

  private func val(value: String?, defaultValue: String) -> String {
    guard let v = value else {
      return defaultValue
    }
    return v
  }

  public func dispatch(adForm: ADForm?) -> ATPRenderer? {
    if tie == nil {
      return nil
    }
    switch tie!.type {
    case .voting:
      return VotingRenderer()
    case .none:
      return nil
    case .error:
      return nil
    }
  }

  public func delegateInteract(atpEvent: ATPEvent, completion: @escaping (String?) -> Void) throws {
    try LibraryAPI.sharedInstance.vote(atpEvent as! Vote, completion: completion)
  }

}

extension String {
  subscript (bounds: CountableClosedRange<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start...end])
  }

  subscript (bounds: CountableRange<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start..<end])
  }
}
