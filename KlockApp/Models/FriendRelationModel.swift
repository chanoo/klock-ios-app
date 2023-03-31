//
//  FriendRelation.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct FriendRelationModel: Codable {
    let id: Int64?
    let requesterId: Int64
    let friendId: Int64
    let accepted: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case requesterId = "requester_id"
        case friendId = "friend_id"
        case accepted
        case createdAt = "created_at"
    }
}
