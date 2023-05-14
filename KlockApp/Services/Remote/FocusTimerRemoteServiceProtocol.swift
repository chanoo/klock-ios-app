//
//  FocusTimerRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/07.
//

import Foundation
import Combine
import Alamofire

protocol FocusTimerRemoteServiceProtocol {
    func create(data: ReqFocusTimer) -> AnyPublisher<FocusTimerDTO, AFError>
    func update(id: Int64, data: ReqFocusTimer) -> AnyPublisher<FocusTimerDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
}
