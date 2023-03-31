//
//  AccountLevel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct AccountLevelModel: Codable {
    let id: Int64?
    let level: Int
    let requiredStudyTime: Int
    let characterName: String
    let characterImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case level
        case requiredStudyTime = "required_study_time"
        case characterName = "character_name"
        case characterImage = "character_image"
    }
}
