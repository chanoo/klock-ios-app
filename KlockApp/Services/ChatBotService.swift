//
//  ChatBotService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Foundation
import Alamofire
import Combine

class ChatBotService: ChatBotServiceProtocol {

    private let baseURL = "https://api.klock.app/api/chatbots"

    func getActiveChatBots() -> AnyPublisher<[ChatBotModel], AFError> {
        let url = "\(baseURL)?active=true"

        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: [ChatBotModel].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
