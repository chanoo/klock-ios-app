//
//  AlamofireLogger.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/09.
//

import Foundation
import Alamofire

class AlamofireLogger: EventMonitor {
    let queue = DispatchQueue(label: "AlamofireLogger")
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("Request: \(request.cURLDescription())")
        print("Response: \(response.debugDescription)")
    }
}
