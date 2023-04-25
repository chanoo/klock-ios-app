//
//  MessageService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Combine
import CoreData

class MessageLocalService: CoreDataHelper, MessageServiceProtocol {
    
    private func mapEntityToModel(_ entity: Message) -> MessageModel {
        return MessageModel(
            content: entity.content ?? "",
            role: entity.role ?? "",
            chatBotID: entity.id
        )
    }
    
    func save(message: MessageModel) -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            do {
                guard let chatBotID = message.chatBotID else {
                    return promise(.failure(NSError(domain: "ChatBotID is missing", code: 1001, userInfo: nil)))
                }
                let fetchedChatBots: [ChatBot] = try self.fetchEntity("ChatBot", id: chatBotID)
                guard let chatBot = fetchedChatBots.first else {
                    return promise(.failure(NSError(domain: "ChatBot not found", code: 1002, userInfo: nil)))
                }
                
                let context = self.coreDataManager.persistentContainer.viewContext
                let messageEntity = Message(context: context)
                
                messageEntity.chatBot = chatBot
                messageEntity.content = message.content
                messageEntity.role = message.role
                messageEntity.timeStamp = Date()

                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func fetch(chatBotID: Int64?) -> AnyPublisher<[MessageModel], Error> {
        return executeFuture { promise in
            do {
                guard let chatBotID = chatBotID else {
                    return promise(.failure(NSError(domain: "ChatBotID is missing", code: 1001, userInfo: nil)))
                }
                let fetchedChatBots: [ChatBot] = try self.fetchEntity("ChatBot", id: chatBotID)
                guard let chatBot = fetchedChatBots.first else {
                    return promise(.failure(NSError(domain: "ChatBot not found", code: 1002, userInfo: nil)))
                }

                let context = self.coreDataManager.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
                fetchRequest.predicate = NSPredicate(format: "chatBot == %@", chatBot)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]

                let fetchedEntities = try context.fetch(fetchRequest)
                let messages = fetchedEntities.map { self.mapEntityToModel($0) }
                promise(.success(messages))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func delete(chatBotID: Int64?) -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Message>(entityName: "Message")

            fetchRequest.predicate = NSPredicate(format: "chatBot.id == %lld", chatBotID ?? 0)

            do {
                let storedMessages = try context.fetch(fetchRequest)

                for message in storedMessages {
                    context.delete(message)
                }

                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
