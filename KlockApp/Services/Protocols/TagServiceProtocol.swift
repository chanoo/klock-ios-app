//
//  TagServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/06.
//

import Foundation
import Combine
import Alamofire

protocol TagServiceProtocol {
    func tags() -> AnyPublisher<[TagResDTO], AFError>
}
