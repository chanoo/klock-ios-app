import Combine
import CoreData

class StudySessionLocalService: CoreDataHelper, StudySessionServiceProtocol {

    private func mapEntityToModel(_ entity: StudySession) -> StudySessionModel {
        return StudySessionModel(id: entity.id, accountId: entity.account?.id ?? 0, startTime: entity.startTime ?? Date(), endTime: entity.endTime ?? Date(), syncDate: nil)
    }

    func fetch() -> AnyPublisher<[StudySessionModel], Error> {
        return executeFuture { promise in
            do {
                let fetchedEntities = try self.fetchEntity("StudySession", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)])
                let studySessions = fetchedEntities.map { self.mapEntityToModel($0 as! StudySession) }
                promise(.success(studySessions))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func save(accountID: Int64, accountTimerID: Int64, startTime: Date, endTime: Date) -> AnyPublisher<StudySessionModel, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "StudySession", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }

            let studySessionEntity = NSManagedObject(entity: entity, insertInto: context) as! StudySession
            studySessionEntity.startTime = startTime
            studySessionEntity.endTime = endTime

            do {
                let lastEntity = try self.fetchEntity("StudySession", sortDescriptors: [NSSortDescriptor(key: "id", ascending: false)], fetchLimit: 1).first as? StudySession
                let id = (lastEntity?.id ?? 0) + 1
                studySessionEntity.id = id

                let fetchedAccounts: [Account] = try self.fetchEntity("Account", id: accountID)
                guard let account = fetchedAccounts.first else {
                    return promise(.failure(NSError(domain: "Account not found", code: 1001, userInfo: nil)))
                }
                studySessionEntity.account = account

                let fetchedAccountTimers: [AccountTimer] = try self.fetchEntity("AccountTimer", id: accountTimerID)
                guard let accountTimer = fetchedAccountTimers.first else {
                    return promise(.failure(NSError(domain: "accountTimer not found", code: 1002, userInfo: nil)))
                }
                studySessionEntity.accountTimer = accountTimer

                try context.save()
                let savedSession = self.mapEntityToModel(studySessionEntity)
                promise(.success(savedSession))
            } catch {
                promise(.failure(error))
            }
        }
    }

    func delete(id: Int64) -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            do {
                if let studySession = try self.fetchEntity("StudySession", id: id).first {
                    context.delete(studySession)
                    try context.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Study session with id \(id) not found", code: 1001, userInfo: nil)))
                }
            } catch {
                promise(.failure(error))
            }
        }
    }

    func deleteAll() -> AnyPublisher<Bool, Error> {
        return executeFuture { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            do {
                let storedSessions = try self.fetchEntity("StudySession")

                for session in storedSessions {
                    context.delete(session)
                }

                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }
    }
}
