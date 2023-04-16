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
    
    init() {
        generateSampleData(startDateString: "20230121", endDateString: "20230413")
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
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
            let sessions = generateSampleStudySessions(forDate: currentDate)
            let dateString = stringFromDate(currentDate)
            debugPrint(currentDate, dateString)
            studySessions[dateString] = sessions
            
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
                endTime: endTime
            )
            
            sessions.append(session)
        }
        
        return sessions
    }
}
