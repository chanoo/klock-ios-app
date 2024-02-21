//
//  APIServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/07.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    func headers() -> HTTPHeaders?
}

extension APIServiceProtocol {
    func headers() -> HTTPHeaders? {
        if let jwtToken = UserDefaults.standard.string(forKey: "access.token") {
            return [
                "Authorization": "Bearer \(jwtToken)"
            ]
        }
        
        return nil
    }
}
