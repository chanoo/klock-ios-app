import Combine
import CoreData

class StudySessionService: StudySessionServiceProtocol {
    private let coreDataManager = CoreDataManager.shared

    func fetchStudySessions() -> AnyPublisher<[StudySessionModel], Error> {
        return Future<[StudySessionModel], Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<StudySession>(entityName: "StudySession")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]

            do {
                let fetchedEntities = try context.fetch(fetchRequest)
                let studySessions = fetchedEntities.map { entity -> StudySessionModel in
                    StudySessionModel(id: entity.id, accountId: 1, startTime: entity.startTime ?? Date(), endTime: entity.endTime ?? Date())
                }
                promise(.success(studySessions))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func saveStudySession(startTime: Date, endTime: Date) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "StudySession", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }

            let studySessionEntity = NSManagedObject(entity: entity, insertInto: context) as! StudySession
            studySessionEntity.startTime = startTime
            studySessionEntity.endTime = endTime

            do {
                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func deleteStoredStudySessions() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<StudySession>(entityName: "StudySession")

            do {
                let storedSessions = try context.fetch(fetchRequest)

                for session in storedSessions {
                    context.delete(session)
                }

                try context.save()
                promise(.success(true))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
