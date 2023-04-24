//
//  CalendarViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import Combine

class CalendarViewModel: ObservableObject {
    @Published var studySessions: [String: [StudySessionModel]] = [:]
    @Published var isLoading: Bool = false
    private let studySessionService = Container.shared.resolve(StudySessionServiceProtocol.self)
    private let accountTimerService = Container.shared.resolve(AccountTimerServiceProtocol.self)
    private let accountService = Container.shared.resolve(AccountServiceProtocol.self)
    private var cancellables = Set<AnyCancellable>()
    // DateFormatter를 프로퍼티로 추가합니다.
    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    init() {
        self.fetchStudySession()
        
        _ = accountService.create(email: "chanoo@gmail.com", username: "차누")
    }
    
    func fetchStudySession() {
        isLoading = true

        studySessionService.fetch()
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching study sessions: \(error)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            } receiveValue: { [weak self] studySessions in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    var groupedStudySessions: [String: [StudySessionModel]] = [:]

                    for session in studySessions {
                        let dateString = self.stringFromDate(session.startTime)
                        if groupedStudySessions[dateString] == nil {
                            groupedStudySessions[dateString] = [session]
                        } else {
                            groupedStudySessions[dateString]?.append(session)
                        }
                    }

                    self.studySessions = groupedStudySessions
                }
            }
            .store(in: &cancellables)
    }

    func deleteStudySessionById(id: Int64) {
        studySessionService.delete(id: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error deleting study session: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { success in
                if success {
                    print("Study session with id \(id) deleted successfully")
                    self.fetchStudySession()
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteStoredStudySessions() {
        studySessionService.deleteAll()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error deleting study sessions: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { success in
                if success {
                    print("Study Sessions deleted successfully")
                    self.studySessions = [:]
                }
            })
            .store(in: &cancellables)
    }
    
    func sortedDates() -> [String] {
        return Array(studySessions.keys).sorted { (date1, date2) -> Bool in
            guard let date1Obj = dateFromString(date1), let date2Obj = dateFromString(date2) else {
                return false
            }
            return date1Obj > date2Obj
        }
    }

    func onDelete(at offsets: IndexSet, dateString: String) {
        guard let index = offsets.first,
              let studySession = studySessions[dateString]?[index],
              let id = studySession.id else {
            return
        }
        deleteStudySessionById(id: id)
    }
    
    func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    func generateSampleData(startDateString: String, endDateString: String) {
        guard let startDate = dateFromString(startDateString),
              let endDate = dateFromString(endDateString) else {
            print("Invalid date format. Use 'yyyyMMdd'.")
            return
        }
        
        generateSampleDataWithDates(startDate: startDate, endDate: endDate)
    }
    
    private func generateSampleDataWithDates(startDate: Date, endDate: Date) {
        let calendar = Calendar.current
        var currentDate = startDate

        let dispatchGroup = DispatchGroup()

        while currentDate <= endDate {
            let shouldGenerateData = Int.random(in: 1...7)

            if shouldGenerateData <= 6 { // 6/7 확률로 샘플 데이터 생성
                dispatchGroup.enter()
                generateSampleStudySessions(forDate: currentDate)
                    .sink(receiveCompletion: { _ in },
                          receiveValue: { sessions in
                              let dateString = self.stringFromDate(currentDate)
                              self.studySessions[dateString] = sessions
                              dispatchGroup.leave()
                          })
                    .store(in: &cancellables)
            }

            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? endDate
        }

        dispatchGroup.notify(queue: .main) {
            // 모든 데이터가 생성되고 studySessions이 업데이트되면 이 블록이 실행됩니다.
            // 필요한 UI 업데이트 또는 다른 작업을 여기서 수행하세요.
        }
    }

    private func generateSampleStudySessions(forDate date: Date) -> AnyPublisher<[StudySessionModel], Error> {
        return Future<[StudySessionModel], Error> { promise in
            let numberOfSessions = Int.random(in: 3...7)
            var sessions: [StudySessionModel] = []

            self.accountTimerService.fetch()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { accountTimers in
                    let dispatchGroup = DispatchGroup()

                    for _ in 0..<numberOfSessions {
                        let randomDuration = TimeInterval(Int.random(in: 600...3600))
                        let startTime = date.addingTimeInterval(-randomDuration)
                        let endTime = date

                        // Select a random AccountTimerModel instance
//                        let randomAccountTimer = accountTimers.randomElement()

                        dispatchGroup.enter()

                        self.studySessionService.save(accountID: 1, accountTimerID: 1, startTime: startTime, endTime: endTime)
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    promise(.failure(error))
                                    dispatchGroup.leave()
                                }
                            }, receiveValue: { savedSession in
                                sessions.append(savedSession)
                                dispatchGroup.leave()
                            }).store(in: &self.cancellables)
                    }

                    dispatchGroup.notify(queue: .main) {
                        promise(.success(sessions))
                    }
                }).store(in: &self.cancellables)
        }.eraseToAnyPublisher()
    }

}
