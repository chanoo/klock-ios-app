//
//  MessageServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Combine
import CoreData

protocol MessageServiceProtocol {
    func save(message: MessageModel) -> AnyPublisher<Bool, Error>
    func fetch(chatBotID: Int64?) -> AnyPublisher<[MessageModel], Error>
    func delete(chatBotID: Int64?) -> AnyPublisher<Bool, Error>
}
