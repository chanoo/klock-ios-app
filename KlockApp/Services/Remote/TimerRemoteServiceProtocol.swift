//
//  TimerRemoteServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/02.
//

import Foundation
import Combine
import Alamofire

protocol TimerRemoteServiceProtocol {
    func fetch() -> AnyPublisher<[TimerDTO], AFError>
}
