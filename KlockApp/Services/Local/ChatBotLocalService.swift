//
//  ChatBotLocalService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import Foundation
import Combine
import Alamofire
import CoreData

class ChatBotLocalService: CoreDataHelper, ChatBotServiceProtocol {
    
    private func mapEntityToModel(_ entity: ChatBot) -> ChatBotModel {
        return ChatBotModel(
            id: entity.id,
            subject: entity.subject ?? "",
            title: entity.title ?? "",
            name: entity.name ?? "",
            chatBotImageUrl: entity.chatBotImageUrl ?? "",
            persona: entity.persona ?? ""
        )
    }
    
    // Add create method to ChatBotLocalService
    func create(chatBotModel: ChatBotModel) -> AnyPublisher<ChatBotModel, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "ChatBot", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }
            
            let chatBotEntity = NSManagedObject(entity: entity, insertInto: context) as! ChatBot
            chatBotEntity.id = chatBotModel.id ?? 0
            chatBotEntity.subject = chatBotModel.subject
            chatBotEntity.title = chatBotModel.title
            chatBotEntity.name = chatBotModel.name
            chatBotEntity.chatBotImageUrl = chatBotModel.chatBotImageUrl
            chatBotEntity.persona = chatBotModel.persona
            
            do {
                try context.save()
                let savedChatBot = self.mapEntityToModel(chatBotEntity)
                promise(.success(savedChatBot))
            } catch {
                promise(.failure(error))
            }

        }
    }

    func fetchBy(active: Bool) -> AnyPublisher<[ChatBotModel], Error> {
        return executeFuture { promise in
            do {
                let fetchedEntities: [ChatBot] = try self.fetchEntity("ChatBot", predicate: NSPredicate(format: "active == %@", NSNumber(value: active)))
                let chatBotModels = fetchedEntities.map { self.mapEntityToModel($0) }
                promise(.success(chatBotModels))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func update(chatBotModel: ChatBotModel) -> AnyPublisher<ChatBotModel, Error> {
        return executeFuture { promise in
            do {
                let fetchedChatBots: [ChatBot] = try self.fetchEntity("ChatBot", id: chatBotModel.id)
                guard let chatBot = fetchedChatBots.first else {
                    return promise(.failure(NSError(domain: "ChatBot with id \(String(describing: chatBotModel.id)) not found", code: 1001, userInfo: nil)))
                }
                chatBot.subject = chatBotModel.subject
                chatBot.title = chatBotModel.title
                chatBot.name = chatBotModel.name
                chatBot.chatBotImageUrl = chatBotModel.chatBotImageUrl
                chatBot.persona = chatBotModel.persona
                try self.coreDataManager.persistentContainer.viewContext.save()
                let updatedChatBot = self.mapEntityToModel(chatBot)
                promise(.success(updatedChatBot))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func sync(with chatBotModels: [ChatBotModel]) -> AnyPublisher<Void, Error> {
        return executeFuture { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "ChatBotLocalService", code: -1, userInfo: [NSLocalizedDescriptionKey: "ChatBotLocalService instance was deallocated"])))
                return
            }

            for chatBotModel in chatBotModels {
                do {
                    let fetchedEntities: [ChatBot] = try self.fetchEntity("ChatBot", id: chatBotModel.id)

                    if let existingChatBot = fetchedEntities.first {
                        existingChatBot.update(with: chatBotModel)
                        try self.coreDataManager.persistentContainer.viewContext.save()
                    } else {
                        _ = self.create(chatBotModel: chatBotModel)
                    }
                } catch {
                    // 오류 처리
                    promise(.failure(error))
                    return
                }
            }
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
}

extension ChatBot {
    func update(with chatBotModel: ChatBotModel) {
        self.id = chatBotModel.id ?? 0
        self.subject = chatBotModel.subject
        self.title = chatBotModel.title
        self.name = chatBotModel.name
        self.chatBotImageUrl = chatBotModel.chatBotImageUrl
        self.persona = chatBotModel.persona
    }
}
