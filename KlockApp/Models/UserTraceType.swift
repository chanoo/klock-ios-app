//
//  UserTraceType.swift
//  KlockApp
//
//  Created by 성찬우 on 2/14/24.
//

enum UserTraceType: String, Codable {
    case activity = "ACTIVITY"
    case studyStart = "STUDY_START" // 공부 시작
    case studyEnd = "STUDY_END"     // 공부 종료
}
