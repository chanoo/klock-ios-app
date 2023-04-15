//
//  StudySession.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct StudySessionModel: Codable {
    let id: Int64?
    let accountId: Int64
    let startTime: Date
    let endTime: Date

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case startTime = "start_time"
        case endTime = "end_time"
    }

    var sessionDuration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
}
