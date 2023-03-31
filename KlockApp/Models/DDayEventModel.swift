//
//  DDayEvent.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct DDayEventModel: Codable {
    let id: Int64?
    let accountId: Int64
    let eventName: String
    let eventDate: Date
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case eventName = "event_name"
        case eventDate = "event_date"
        case createdAt = "created_at"
    }
}
