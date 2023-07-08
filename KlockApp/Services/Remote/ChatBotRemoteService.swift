//
//  ChatBotService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Foundation
import Alamofire
import Combine

class ChatBotRemoteService: ChatBotRemoteServiceProtocol {

    private let baseURL = "https://api.klock.app/api/v1/chat-bots"

    func fetchBy(active: Bool) -> AnyPublisher<[ChatBotModel], Error> {
        let url = "\(baseURL)?active=\(active)"

        return AF.request(url, method: .get, encoding: JSONEncoding.default)
            .validate()
            .publishDecodable(type: [ChatBotModel].self)
            .value()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
