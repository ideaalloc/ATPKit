/*
 * Copyright (c) 2018 Atlas Protocol
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Foundation
import Alamofire
import Renderer

class HTTPClient {
  fileprivate var baseEP: String?

  let headers = [
    //      "Authorization": "Bearer " + kTIE,
    "Accept": "application/json"
  ]

  init(baseEP: String) {
    self.baseEP = baseEP
  }

  func getRequest(_ uri: String, completion: @escaping (String?) -> Void) throws {
    guard Connectivity.isConnectedToInternet else {
      throw ATPError.net
    }

    Alamofire.request(baseEP! + uri, headers: headers)
        .responseString { response in
          debugPrint(response)
          guard response.result.isSuccess,
                let value = response.result.value else {
            print("Error while getting response: \(String(describing: response.result.error))")
            completion(nil)
            return
          }
          completion(value)
        }
  }

  func postRequest(_ uri: String, body: String?, completion: @escaping (String?) -> Void) throws {
    guard Connectivity.isConnectedToInternet else {
      throw ATPError.net
    }

    var parameters: Parameters = [:]
    let data = body?.data(using: .utf8)
    if let parameterData = data,
       let decodedParameter = try? JSONSerialization.jsonObject(with: parameterData) as! [String: String] {
      parameters = decodedParameter
    }
    Alamofire.request(baseEP! + uri
            , method: .post
            , parameters: parameters
            , encoding: JSONEncoding.default
            , headers: headers).debugLog()
        .responseString { response in
          debugPrint(response)
          guard response.result.isSuccess,
                let value = response.result.value else {
            print("Error while getting response: \(String(describing: response.result.error))")
            completion(nil)
            return
          }
          completion(value)
        }
  }

}

extension Request {
  public func debugLog() -> Self {
    debugPrint("=======================================")
    debugPrint(self)
    debugPrint("=======================================")
    return self
  }
}
