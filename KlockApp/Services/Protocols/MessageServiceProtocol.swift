//
//  MessageServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Combine
import CoreData

protocol MessageServiceProtocol {
    func saveMessage(message: MessageModel) -> AnyPublisher<Bool, Error>
    func fetchMessages(chatBotID: Int64?) -> AnyPublisher<[MessageModel], Error>
    func deleteStoredMessages(chatBotID: Int64?) -> AnyPublisher<Bool, Error>
}
