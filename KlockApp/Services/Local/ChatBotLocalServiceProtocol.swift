//
//  ChatBotLocalServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/28.
//

import Foundation
import Combine

protocol ChatBotLocalServiceProtocol {
    func fetchBy(active: Bool) -> AnyPublisher<[ChatBotModel], Error>
}
