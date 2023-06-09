//
//  SocialLogin.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

enum SocialProvider: String, Codable {
    case apple = "애플"
    case facebook = "페이스북"
    case kakao = "카카오"
}

struct SocialLoginModel: Codable {
    let id: Int64?
    let provider: SocialProvider
    let providerUserId: String
    let accountId: Int64
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case provider
        case providerUserId = "provider_user_id"
        case accountId = "account_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
