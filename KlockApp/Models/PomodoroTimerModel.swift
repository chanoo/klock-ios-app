//
//  PomodoroTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

struct PomodoroTimerModel: Identifiable, Codable {
    let id: Int64?
    let accountTimerId: Int64
    let title: String
    let studyTime: Int
    let restTime: Int
    let cycleCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case accountTimerId = "account_timer_id"
        case title
        case studyTime = "study_time"
        case restTime = "rest_time"
        case cycleCount = "cycle_count"
    }
}
