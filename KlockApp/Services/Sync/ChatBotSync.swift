//
//  ChatBotSync.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/25.
//

import Foundation
import Combine

class ChatBotSync: ChatBotSyncProtocol {
    private let chatBotRemoteService: ChatBotRemoteService
    private let chatBotLocalService: ChatBotLocalService

    private var cancellables = Set<AnyCancellable>()

    init(chatBotRemoteService: ChatBotRemoteService, chatBotLocalService: ChatBotLocalService) {
        self.chatBotRemoteService = chatBotRemoteService
        self.chatBotLocalService = chatBotLocalService
    }

    func sync() -> AnyPublisher<Void, Error> {
        return chatBotRemoteService.fetchBy(active: true)
            .flatMap { chatBotModels -> AnyPublisher<Void, Error> in
                return self.chatBotLocalService.sync(with: chatBotModels)
            }
            .eraseToAnyPublisher()
    }
}
