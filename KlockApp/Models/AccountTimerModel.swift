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
    let accountId: Int64?
    let type: AccountTimerType
    let active: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case type
        case active
        case createdAt = "created_at"
    }
}
