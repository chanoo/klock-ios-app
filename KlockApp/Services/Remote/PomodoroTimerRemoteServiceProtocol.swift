//
//  PomodoroTimerRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/07.
//

import Foundation
import Combine
import Alamofire

protocol PomodoroTimerRemoteServiceProtocol {
    func create(data: ReqPomodoroTimer) -> AnyPublisher<PomodoroTimerDTO, AFError>
    func update(id: Int64, data: ReqPomodoroTimer) -> AnyPublisher<PomodoroTimerDTO, AFError>
    func delete(id: Int64) -> AnyPublisher<Void, AFError>
}
