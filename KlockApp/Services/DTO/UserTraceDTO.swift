//
//  UserTraceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2/13/24.
//

import Foundation

struct UserTraceFetchResDTO: Codable, Hashable {
    let id: Int64
    let writeUserId: Int64
    let writeUserImage: String?
    let contents: String
    let contentsImage: String?
    let heart: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case writeUserId
        case writeUserImage
        case contents
        case contentsImage
        case heart
        case createdAt
    }
}

struct UserTraceCreateReqDTO: Codable {
    let contentTrace: UserTraceCreateReqContentTraceDTO
    let image: Data?
}

struct UserTraceCreateReqContentTraceDTO: Codable {
    let writeUserId: Int64
    let contents: String
}

struct UserTraceCreateResDTO: Codable {
    let id: Int64
    let writeUserId: Int64
    let writeUserImage: String?
    let contents: String
    let contentsImage: String?
    let heart: Bool
    let createdAt: String
}
