//
//  AccountLocalService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import Foundation
import Combine
import CoreData

class AccountLocalService: CoreDataHelper, AccountLocalServiceProtocol {
    
    private func mapEntityToModel(_ entity: Account) -> UserModel {
        return UserModel(
            id: entity.id,
            accessToken: "",
            refreshToken: "",
            nickname: entity.username ?? "",
            profileImage: entity.profileImage,
            tagId: 0,
            startOfTheWeek: "SUNDAY",
            startOfTheDay: 5,
            totalStudyTime: Int(entity.totalStudyTime))
    }
    
    func get(id: Int64) -> AnyPublisher<UserModel, Error> {
        return executeFuture { promise in
            do {
                let fetchedEntities: [Account] = try self.fetchEntity("Account", id: id)
                if let account = fetchedEntities.first {
                    let accountModel = self.mapEntityToModel(account)
                    promise(.success(accountModel))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func create(email: String, username: String) -> AnyPublisher<UserModel, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "Account", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }
            
            let now = Date()
            let accountEntity = NSManagedObject(entity: entity, insertInto: context) as! Account
            accountEntity.email = email
            accountEntity.username = username
            accountEntity.totalStudyTime = 0
            accountEntity.role = UserRole.user.rawValue
            accountEntity.active = true
            accountEntity.createdAt = now
            accountEntity.updatedAt = now

            do {
                let lastEntity = try self.fetchEntity("Account", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], fetchLimit: 1).first as? Account
                let id = (lastEntity?.id ?? 0) + 1
                accountEntity.id = id
                
                try context.save()
                let savedAccount = self.mapEntityToModel(accountEntity)
                promise(.success(savedAccount))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func fetch() -> AnyPublisher<[UserModel], Error> {
        return executeFuture { promise in
            do {
                let fetchedEntities = try self.fetchEntity("Account", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
                let accounts = fetchedEntities.map { self.mapEntityToModel($0 as! Account) }
                promise(.success(accounts))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func update(id: Int64, email: String?, username: String?, totalStudyTime: Int?, active: Bool?) -> AnyPublisher<UserModel, Error> {
        return executeFuture { promise in
            do {
                let fetchedAccounts: [Account] = try self.fetchEntity("Account", id: id)
                if let account = fetchedAccounts.first {
                    account.email = email ?? account.email
                    account.username = username ?? account.username
                    account.totalStudyTime = account.totalStudyTime
                    account.role = account.role
                    account.active = active ?? account.active
                    account.updatedAt = Date()
                    
                    try self.coreDataManager.persistentContainer.viewContext.save()
                    let updatedAccount = self.mapEntityToModel(account)
                    promise(.success(updatedAccount))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func delete(id: Int64) -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            do {
                let fetchedAccounts: [Account] = try self.fetchEntity("Account", id: id)
                if let account = fetchedAccounts.first {
                    self.coreDataManager.persistentContainer.viewContext.delete(account)
                    try self.coreDataManager.persistentContainer.viewContext.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }
}
