//
//  APIError.swift
//  KlockApp
//
//  Created by 성찬우 on 2/27/24.
//
import Alamofire

public enum APIError: Error {
    init(error: AFError) {
        self = .network
    }
    
    case network
    case custom(Int, String)
    case nilResponse // 추가된 케이스

    var code: Int {
        switch self {
        case .network:
            return 0
        case .custom(let code, _):
            return code
        case .nilResponse:
            return 0
        }
    }
    
    var message: String {
        switch self {
        case .network:
            return "Network Error"
        case .custom(_, let message):
            return message
        case .nilResponse:
            return "Network Error"
        }
    }
}
