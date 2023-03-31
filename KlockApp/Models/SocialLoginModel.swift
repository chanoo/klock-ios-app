//
//  SocialLogin.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

enum SocialProvider: String, Codable {
    case google
    case facebook
    case twitter
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
