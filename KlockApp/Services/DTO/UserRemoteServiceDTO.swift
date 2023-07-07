//
//  UserRemoteServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation

struct ExistedNickNameReqDTO: Codable {
    let nickName: String
}

struct ExistedNickNameResDTO: Codable {
    let exists: Bool
}

struct GetUserResDTO: Codable {
    let id: Int64
    let nickName: String
    let email: String?
    let level: Int
    let requiredStudyTime: Int
    let characterName: String
    let characterImage: String
    let startOfTheWeek: String
    let startOfTheDay: Int
    let tagId: Int64
}
