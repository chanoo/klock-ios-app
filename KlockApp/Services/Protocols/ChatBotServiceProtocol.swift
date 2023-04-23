//
//  ChatBotServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Foundation
import Combine
import Alamofire

protocol ChatBotServiceProtocol {
    func getActiveChatBots() -> AnyPublisher<[ChatBotModel], AFError>
}
