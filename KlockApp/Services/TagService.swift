//
//  TagService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/06.
//

import Foundation
import Alamofire
import Combine

class TagService: TagServiceProtocol {
    
    private let baseURL = "https://api.klock.app/api/tags"

    func tags() -> AnyPublisher<[TagResDTO], Alamofire.AFError> {
        let url = "\(baseURL)"

        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: [TagResDTO].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
}
