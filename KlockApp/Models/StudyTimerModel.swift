//
//  StudyTimerModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/23.
//

import Foundation

struct StudyTimerModel: Identifiable, Codable {
    let id: Int64?
    let accountTimerId: Int64
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountTimerId = "account_timer_id"
        case title
    }
}
