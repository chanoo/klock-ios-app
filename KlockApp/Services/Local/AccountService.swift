//
//  AccountService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import Foundation
import Combine
import CoreData

class AccountService: AccountServiceProtocol {

    private let coreDataManager = CoreDataManager.shared

    func get(id: Int64) -> AnyPublisher<Account, Error> {
        return Future<Account, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                if let account = try context.fetch(fetchRequest).first {
                    promise(.success(account))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func create(email: String, username: String) -> AnyPublisher<Account, Error> {
        return Future<Account, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "Account", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }
            
            let now = Date()
            let accountEntity = NSManagedObject(entity: entity, insertInto: context) as! Account
            accountEntity.email = email
            accountEntity.username = username
            accountEntity.totalStudyTime = 0
            accountEntity.role = AccountRole.user.rawValue
            accountEntity.active = true
            accountEntity.createdAt = now
            accountEntity.updatedAt = now

            // Assign auto-incrementing ID
            let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let lastEntity = try context.fetch(fetchRequest).first
                let id = (lastEntity?.id ?? 0) + 1
                accountEntity.id = id
                
                try context.save()
                promise(.success(accountEntity))
            } catch {
                promise(.failure(error))
            }

        }.eraseToAnyPublisher()
    }
    
    func fetch() -> AnyPublisher<[Account], Error> {
        return Future<[Account], Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
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
    
    func update(id: Int64, email: String?, username: String?, totalStudyTime: Int?, active: Bool?) -> AnyPublisher<Account, Error> {
        return Future<Account, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1
            
            do {
                if let account = try context.fetch(fetchRequest).first {
                    account.email = email ?? account.email
                    account.username = username ?? account.username
                    account.totalStudyTime = account.totalStudyTime
                    account.role = account.role
                    account.active = active ?? account.active
                    account.updatedAt = Date()
                    
                    try context.save()
                    promise(.success(account))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(id: Int64) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Account>(entityName: "Account")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                if let account = try context.fetch(fetchRequest).first {
                    context.delete(account)
                    try context.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Account with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}

extension Account {
    func toModel() -> AccountModel {
        return AccountModel(
            id: self.id,
            email: self.email,
            hashedPassword: nil,
            username: self.username ?? "",
            totalStudyTime: Int(self.totalStudyTime),
            accountLevelId: 1,
            role: AccountRole(rawValue: self.role ?? "") ?? .user,
            active: self.active,
            createdAt: self.createdAt ?? Date(),
            updatedAt: self.updatedAt ?? Date()
        )
    }
}
