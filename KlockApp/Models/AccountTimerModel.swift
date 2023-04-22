//
//  AccountTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

enum AccountTimerType: String, Codable {
    case study
    case pomodoro
    case exam
}

struct AccountTimerModel: Codable {
    let id: Int64?
    let type: AccountRole
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case createdAt = "created_at"
    }
}
