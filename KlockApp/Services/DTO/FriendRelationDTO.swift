//
//  FriendRelationDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 11/17/23.
//

import Foundation

struct FriendRelationFetchResDTO: Codable, Hashable {
    let followId: Int64
    let nickname: String
    let totalStudyTime: Int64
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case followId
        case nickname
        case totalStudyTime
        case profileImage
    }
}
