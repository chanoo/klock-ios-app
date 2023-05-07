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
    func create(data: FocusTimerDTO) -> AnyPublisher<FocusTimerDTO, Error>
    func update(id: Int64, data: FocusTimerDTO) -> AnyPublisher<FocusTimerDTO, Error>
    func delete(id: Int64) -> AnyPublisher<Void, Error>
}
