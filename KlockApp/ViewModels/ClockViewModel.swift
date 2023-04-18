//
//  ClockViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI
import Combine

class ClockViewModel: ObservableObject {
    
    private let studyTimeKey = "studyTime"
     private let savedTimeKey = "savedTime" // Add this line
     @Published var studySessions: [StudySessionModel] = []
     @Published var elapsedTime: TimeInterval = 0
     @Published var clockModel: ClockModel

    private let studySessionService: StudySessionServiceProtocol = Container.shared.resolve(StudySessionServiceProtocol.self)

    var cancellables: Set<AnyCancellable> = []

    init(clockModel: ClockModel) {
         self.clockModel = clockModel
         self.studySessions = []
         self.studySessions = generateSampleStudySessions()
         loadStudyTime()
         saveStudyTime() // Add this line
     }
     
     deinit {
         saveStudyTime()
     }
    
    func stopAndSaveStudySession() {
        let startTime = Date().addingTimeInterval(-elapsedTime)
        let endTime = Date()
        
        studySessionService.saveStudySession(startTime: startTime, endTime: endTime)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error saving study session: \(error)")
                case .finished:
                    print("Study session saved successfully")
                }
            }, receiveValue: { _ in
                self.deleteStudyTime()
            })
            .store(in: &cancellables)
    }

     func saveStudyTime() {
         UserDefaults.standard.set(elapsedTime, forKey: studyTimeKey)
         let now = Date().timeIntervalSince1970 // Add this line
         UserDefaults.standard.set(now, forKey: savedTimeKey) // Add this line
     }

     func loadStudyTime() {
         elapsedTime = UserDefaults.standard.double(forKey: studyTimeKey)
         calculateElapsedTime() // Add this line
     }
    
    func deleteStudyTime() {
        elapsedTime = 0
        UserDefaults.standard.removeObject(forKey: studyTimeKey)
    }

     func calculateElapsedTime() {
         let savedTime = UserDefaults.standard.double(forKey: savedTimeKey)
         if savedTime != 0 {
             let currentTime = Date().timeIntervalSince1970
             let timeDifference = currentTime - savedTime
             elapsedTime += timeDifference
             saveStudyTime()
         }
     }

    func generateSampleStudySessions() -> [StudySessionModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        let sampleTimes: [(start: String, end: String)] = [
            (start: "2023/04/15 08:00", end: "2023/04/15 08:50"),
            (start: "2023/04/15 09:00", end: "2023/04/15 09:50"),
            (start: "2023/04/15 11:00", end: "2023/04/15 11:50"),
            (start: "2023/04/15 13:00", end: "2023/04/15 13:50"),
            (start: "2023/04/15 15:00", end: "2023/04/15 15:50"),
            (start: "2023/04/15 16:00", end: "2023/04/15 16:50"),
            (start: "2023/04/15 18:00", end: "2023/04/15 18:50"),
            (start: "2023/04/15 19:00", end: "2023/04/15 19:50"),
            (start: "2023/04/15 20:00", end: "2023/04/15 20:50"),
            (start: "2023/04/15 21:00", end: "2023/04/15 23:59")
        ]

        // 수정된 부분
        var sampleStudySessions: [StudySessionModel] = []
        
        for i in 0..<sampleTimes.count {
            if let startTime = dateFormatter.date(from: sampleTimes[i].start),
               let endTime = dateFormatter.date(from: sampleTimes[i].end) {
                let studySession = StudySessionModel(id: Int64(i), accountId: 1, startTime: startTime, endTime: endTime)
                sampleStudySessions.append(studySession)
            }
        }

        return sampleStudySessions
    }

    func updateClockSize(_ size: CGSize) {
        clockModel.clockSize = size
    }

}
