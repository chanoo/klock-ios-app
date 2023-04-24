//
//  AccountTimerService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation
import Combine
import CoreData

class AccountTimerLocalService: AccountTimerServiceProtocol {
    private let coreDataManager = CoreDataManager.shared

    func create(account: Account, type: String, active: Bool) -> AnyPublisher<AccountTimer, Error> {
        return Future<AccountTimer, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "AccountTimer", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }

            let accountTimerEntity = NSManagedObject(entity: entity, insertInto: context) as! AccountTimer
            accountTimerEntity.account = account
            accountTimerEntity.type = type
            accountTimerEntity.active = active
            accountTimerEntity.createdAt = Date()

            do {
                try context.save()
                promise(.success(accountTimerEntity))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func fetch() -> AnyPublisher<[AccountTimer], Error> {
        return Future<[AccountTimer], Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AccountTimer>(entityName: "AccountTimer")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "id", ascending: false),
            ]

            do {
                let fetchedEntities = try context.fetch(fetchRequest)
                promise(.success(fetchedEntities))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func delete(id: Int64) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AccountTimer>(entityName: "AccountTimer")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                if let accountTimer = try context.fetch(fetchRequest).first {
                    context.delete(accountTimer)
                    try context.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Account timer with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func update(id: Int64, active: Bool) -> AnyPublisher<AccountTimer, Error> {
        return Future<AccountTimer, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<AccountTimer>(entityName: "AccountTimer")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                if let accountTimer = try context.fetch(fetchRequest).first {
                    accountTimer.active = active
                    try context.save()
                    promise(.success(accountTimer))
                } else {
                    promise(.failure(NSError(domain: "Account timer with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

extension AccountTimer {
    func toModel() -> AccountTimerModel {
        return AccountTimerModel(id: self.id, accountId: self.account?.id, type: AccountTimerType(rawValue: self.type ?? "") ?? .study, active: self.active, createdAt: self.createdAt ?? Date())
    }
}
