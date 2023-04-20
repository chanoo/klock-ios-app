import Combine
import CoreData

class StudySessionService: StudySessionServiceProtocol {

    private let coreDataManager = CoreDataManager.shared

    func fetchStudySessions() -> AnyPublisher<[StudySessionModel], Error> {
        return Future<[StudySessionModel], Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<StudySession>(entityName: "StudySession")
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "id", ascending: false),
            ]

            do {
                let fetchedEntities = try context.fetch(fetchRequest)
                let studySessions = fetchedEntities.map { entity -> StudySessionModel in
                    StudySessionModel(id: entity.id, accountId: 1, startTime: entity.startTime ?? Date(), endTime: entity.endTime ?? Date(), syncDate: nil)
                }
                promise(.success(studySessions))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }


    func saveStudySession(startTime: Date, endTime: Date) -> AnyPublisher<StudySessionModel, Error> {
        return Future<StudySessionModel, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "StudySession", in: context) else {
                return promise(.failure(NSError(domain: "Error in creating entity", code: 1000, userInfo: nil)))
            }

            let studySessionEntity = NSManagedObject(entity: entity, insertInto: context) as! StudySession
            studySessionEntity.startTime = startTime
            studySessionEntity.endTime = endTime
            
            // Assign auto-incrementing ID
            let fetchRequest = NSFetchRequest<StudySession>(entityName: "StudySession")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
            fetchRequest.fetchLimit = 1

            do {
                let lastEntity = try context.fetch(fetchRequest).first
                let id = (lastEntity?.id ?? 0) + 1
                studySessionEntity.id = id
            } catch {
                promise(.failure(error))
                return
            }

            do {
                try context.save()
                let savedSession = StudySessionModel(id: studySessionEntity.id, accountId: 1, startTime: studySessionEntity.startTime ?? Date(), endTime: studySessionEntity.endTime ?? Date(), syncDate: nil)
                promise(.success(savedSession))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func deleteStudySessionById(id: Int64) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            let context = self.coreDataManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<StudySession>(entityName: "StudySession")
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                if let studySession = try context.fetch(fetchRequest).first {
                    context.delete(studySession)
                    try context.save()
                    promise(.success(true))
                } else {
                    promise(.failure(NSError(domain: "Study session with id \(id) not found", code: 1001, userInfo: nil)))
                }
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
