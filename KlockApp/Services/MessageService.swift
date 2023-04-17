//
//  MessageService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Combine
import CoreData

class MessageService: MessageServiceProtocol {
    private let coreDataManager = CoreDataManager.shared

    func saveMessage(message: MessageModel) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "Message", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }
            guard let chatBotID = message.chatBotID else {
                return promise(.failure(NSError(domain: "ChatBotID is missing", code: 1001, userInfo: nil)))
            }
            
            let messageEntity = NSManagedObject(entity: entity, insertInto: context) as! Message
            messageEntity.content = message.content
            messageEntity.role = message.role
            messageEntity.chatBotID = chatBotID
            messageEntity.timeStamp = Date()

            do {
                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func fetchMessages(chatBotID: Int64?) -> AnyPublisher<[MessageModel], Error> {
        return Future<[MessageModel], Error> { promise in
            guard let chatBotID = chatBotID else {
                return promise(.failure(NSError(domain: "ChatBotID is missing", code: 1001, userInfo: nil)))
            }

            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
            fetchRequest.predicate = NSPredicate(format: "chatBotID == %@", NSNumber(value: chatBotID))
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]

            do {
                let fetchedEntities = try context.fetch(fetchRequest)
                let messages = fetchedEntities.map { entity -> MessageModel in
                    MessageModel(content: entity.content ?? "", role: entity.role ?? "", chatBotID: entity.chatBotID)
                }
                promise(.success(messages))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func deleteStoredMessages(chatBotID: Int64?) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            guard let chatBotID = chatBotID else {
                return promise(.failure(NSError(domain: "ChatBot ID is missing", code: 1001, userInfo: nil)))
            }

            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
            fetchRequest.predicate = NSPredicate(format: "chatBotID == %lld", chatBotID)

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
