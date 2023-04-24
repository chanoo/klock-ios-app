//
//  AccountTimerService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Combine
import CoreData

class AccountTimerLocalService: CoreDataHelper, AccountTimerServiceProtocol {
    
    private func mapEntityToModel(_ entity: AccountTimer) -> AccountTimerModel {
        return AccountTimerModel(id: entity.id, accountId: entity.account?.id, type: AccountTimerType(rawValue: entity.type ?? "") ?? .study, active: entity.active, createdAt: entity.createdAt ?? Date())
    }
    
    func fetch() -> AnyPublisher<[AccountTimerModel], Error> {
        return executeFuture { promise in
            do {
                let fetchedEntities: [AccountTimer] = try self.fetchEntity("AccountTimer", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
                let accountTimers = fetchedEntities.map { self.mapEntityToModel($0) }
                promise(.success(accountTimers))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func create(accountID: Int64, type: String, active: Bool) -> AnyPublisher<AccountTimerModel, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "AccountTimer", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }

            let accountTimerEntity = NSManagedObject(entity: entity, insertInto: context) as! AccountTimer
            accountTimerEntity.type = type
            accountTimerEntity.active = active
            accountTimerEntity.createdAt = Date()

            do {
                let lastEntity: AccountTimer? = try self.fetchEntity("AccountTimer", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], fetchLimit: 1).first
                let id = (lastEntity?.id ?? 0) + 1
                accountTimerEntity.id = id

                let fetchedAccounts: [Account] = try self.fetchEntity("Account", id: accountID)
                guard let account = fetchedAccounts.first else {
                    return promise(.failure(NSError(domain: "Account not found", code: 1001, userInfo: nil)))
                }
                accountTimerEntity.account = account

                try context.save()
                let createdTimer = self.mapEntityToModel(accountTimerEntity)
                promise(.success(createdTimer))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func delete(id: Int64) -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            do {
                let fetchedAccountTimers: [AccountTimer] = try self.fetchEntity("AccountTimer", id: id)
                if let accountTimer = fetchedAccountTimers.first {
                    self.coreDataManager.persistentContainer.viewContext.delete(accountTimer)
                    try self.coreDataManager.persistentContainer.viewContext.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Account timer with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func update(id: Int64, active: Bool) -> AnyPublisher<AccountTimerModel, Error> {
        return executeFuture { promise in
            do {
                let fetchedAccountTimers: [AccountTimer] = try self.fetchEntity("AccountTimer", id: id)
                guard let accountTimer = fetchedAccountTimers.first else {
                    return promise(.failure(NSError(domain: "Account timer with id \(id) not found", code: 1001, userInfo: nil)))
                }
                accountTimer.active = active
                try self.coreDataManager.persistentContainer.viewContext.save()
                let updatedTimer = self.mapEntityToModel(accountTimer)
                promise(.success(updatedTimer))
            } catch {
                promise(.failure(error))
            }
        }
    }
}

extension AccountTimer {
    func toModel() -> AccountTimerModel {
        return AccountTimerModel(id: self.id, accountId: self.account?.id, type: AccountTimerType(rawValue: self.type ?? "") ?? .study, active: self.active, createdAt: self.createdAt ?? Date())
    }
}
