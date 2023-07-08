//
//  StudySession.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct StudySessionModel: Identifiable, Codable {
    let id: Int64?
    let userId: Int64
    let startTime: Date
    let endTime: Date
    let timerName: String
    let timerType: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case startTime
        case endTime
        case timerName
        case timerType
    }
    
    static func from(dto: GetStudySessionsResDTO) -> StudySessionModel {
        return StudySessionModel(
            id: dto.id,
            userId: dto.userId,
            startTime: TimeUtils.dateFromString(dateString: dto.startTime, format: "yyyy-MM-dd'T'HH:mm:ss") ?? Date(),
            endTime: TimeUtils.dateFromString(dateString: dto.endTime, format: "yyyy-MM-dd'T'HH:mm:ss") ?? Date(),
            timerName: dto.timerName,
            timerType: dto.timerType
        )
    }

    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }
}
