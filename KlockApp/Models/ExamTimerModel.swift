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
    let questionCount: Int
    let markingTime: Int

    enum CodingKeys: String, CodingKey {
        case id
        case accountTimerId
        case title
        case startTime
        case duration
        case questionCount
        case markingTime
    }
}
