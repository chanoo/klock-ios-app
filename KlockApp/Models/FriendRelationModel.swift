//
//  FriendRelation.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct FriendRelationModel: Codable {
    let id: Int64?
    let userId: Int64?
    let followId: Int64
    let followed: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case followId = "follow_id"
        case followed
        case createdAt = "created_at"
    }
}
