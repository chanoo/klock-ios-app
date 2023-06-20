//
//  UserModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation

enum UserRole: String, Codable {
    case admin
    case user
}

struct UserModel: Hashable, Codable {
    let id: Int64?
    let email: String?
    let hashedPassword: String?
    let username: String
    let profileImage: String?
    let totalStudyTime: Int
    let accountLevelId: Int64
    let role: UserRole
    let active: Bool
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case hashedPassword = "hashed_password"
        case username
        case profileImage = "profile_image"
        case totalStudyTime = "total_study_time"
        case accountLevelId = "account_level_id"
        case role
        case active
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
