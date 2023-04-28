//
//  ChatBotServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Foundation
import Combine

protocol ChatBotRemoteServiceProtocol {
    func fetchBy(active: Bool) -> AnyPublisher<[ChatBotModel], Error>
}
