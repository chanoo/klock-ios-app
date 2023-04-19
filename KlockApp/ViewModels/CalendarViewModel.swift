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
    private let studySessionService: StudySessionServiceProtocol = Container.shared.resolve(StudySessionServiceProtocol.self)
    private var cancellables = Set<AnyCancellable>()

    init() {
//        self.generateSampleData(startDateString: "20230120", endDateString: "20230413")
        self.fetchStudySession()
    }
    
    private func fetchStudySession() {
        
        studySessionService.fetchStudySessions()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching study sessions: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { studySessions in
                DispatchQueue.main.async {
                    var groupedStudySessions: [String: [StudySessionModel]] = [:]

                    for session in studySessions {
                        debugPrint("session", session)
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
    
    func deleteStoredStudySessions() {
        studySessionService.deleteStoredStudySessions()
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
        
        while currentDate <= endDate {
            let shouldGenerateData = Int.random(in: 1...7)
            
            if shouldGenerateData <= 6 { // 6/7 확률로 샘플 데이터 생성
                let sessions = generateSampleStudySessions(forDate: currentDate)
                let dateString = stringFromDate(currentDate)
                studySessions[dateString] = sessions
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? endDate
        }
    }

    private func generateSampleStudySessions(forDate date: Date) -> [StudySessionModel] {
        let numberOfSessions = Int.random(in: 3...7)
        var sessions: [StudySessionModel] = []
        
        for _ in 0..<numberOfSessions {
            let randomDuration = TimeInterval(Int.random(in: 600...3600))
            let startTime = date.addingTimeInterval(-randomDuration)
            let endTime = date
            
            let session = StudySessionModel(
                id: Int64.random(in: 1...10000),
                accountId: Int64.random(in: 1...100),
                startTime: startTime,
                endTime: endTime,
                syncDate: nil
            )
            
            sessions.append(session)
        }
        
        return sessions
    }
}
