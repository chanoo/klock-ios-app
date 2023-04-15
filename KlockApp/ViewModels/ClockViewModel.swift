//
//  ClockViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation
import SwiftUI

class ClockViewModel: ObservableObject {
    @Published var clockModel: ClockModel
    @Published var elapsedTime: TimeInterval = 0
    var studySessions: [StudySessionModel]
    
    init(clockModel: ClockModel) {
        self.clockModel = clockModel
        self.studySessions = []
        self.studySessions = generateSampleStudySessions()
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
