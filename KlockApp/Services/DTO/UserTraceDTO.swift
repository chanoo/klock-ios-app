//
//  UserTraceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2/13/24.
//

import Foundation

struct UserTraceResDTO: Codable, Hashable {
    let id: Int64
    let writeUserId: Int64
    let writeNickname: String
    let writeUserImage: String?
    let type: UserTraceType
    let contents: String
    let contentsImage: String?
    var heartCount: Int
    var createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case writeUserId
        case writeNickname
        case writeUserImage
        case type
        case contents
        case contentsImage
        case heartCount
        case createdAt
    }
}

struct UserTraceCreateReqDTO: Codable {
    let contentTrace: UserTraceCreateReqContentTraceDTO
    var image: Data? = nil
}

struct UserTraceCreateReqContentTraceDTO: Codable {
    let userId: Int64
    let writeUserId: Int64
    let type: UserTraceType
    let contents: String?
}
