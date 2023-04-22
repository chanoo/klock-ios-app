//
//  ExamTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

struct ExamTimerModel: Identifiable, Codable {
    let id: Int64?
    let accountTimerId: Int64
    let title: String
    let startTime: Date
    let duration: Int

    enum CodingKeys: String, CodingKey {
        case id
        case accountTimerId = "account_timer_id"
        case title
        case startTime = "start_time"
        case duration = "duration"
    }
}
