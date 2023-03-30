//
//  Account.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation

struct Account: Codable {
    let id: Int
    let email: String
    let username: String
    let total_study_time: Int
    let account_level_id: Int
    let role: String
    let active: Bool
    let created_at: Date
    let updated_at: Date
}
