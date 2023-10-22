//
//  AutoTimerRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/21.
//

import Foundation
import Combine
import Alamofire

protocol AutoTimerRemoteServiceProtocol {
    func create(data: ReqAutoTimer) -> AnyPublisher<AutoTimerDTO, AFError>
    func update(id: Int64, data: ReqAutoTimer) -> AnyPublisher<AutoTimerDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
}
