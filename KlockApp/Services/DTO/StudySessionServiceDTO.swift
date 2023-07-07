//
//  StudySessionServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation

struct ReqStudySession: Codable {
    let userId: Int64?
    let timerName: String
    let timerType: TimerType
    let startTime: String
    let endTime: String?
    
    init(userId: Int64? = 56, timerName: String, timerType: TimerType, startTime: String, endTime: String? = nil) {
        self.userId = userId
        self.timerName = timerName
        self.timerType = timerType
        self.startTime = startTime
        self.endTime = endTime
    }
}

struct ResStudySession: Codable {
    let id: Int64
    let userId: Int64
    let startTime: String
    let endTime: String?
}
