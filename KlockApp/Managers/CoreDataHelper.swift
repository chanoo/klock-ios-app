//
//  CoreDataHelper.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/24.
//

import CoreData
import Combine

class CoreDataHelper {
    let coreDataManager = CoreDataManager.shared
    
    func fetchRequestForEntity<T: NSManagedObject>(_ entityName: String, id: Int64? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        }
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        return fetchRequest
    }
    
    func fetchEntity<T: NSManagedObject>(_ entityName: String, id: Int64? = nil, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil) throws -> [T] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        if let id = id {
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
        } else if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        }

        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        return try context.fetch(fetchRequest)
    }

    
    func executeFuture<T>(_ work: @escaping (Future<T, Error>.Promise) -> Void) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            work(promise)
        }.eraseToAnyPublisher()
    }
}
