//
//  UserRemoteServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/07.
//

import Foundation

struct ExistedNicknameReqDTO: Codable {
    let nickname: String
}

struct UserUpdateReqDTO: Codable {
    let nickname: String
    let tagId: Int64
    let startOfTheWeek: String
    let startOfTheDay: Int
}

struct UserUpdateResDTO: Codable {
    let id: Int64
    let nickname: String
    let email: String?
    let profileImage: String?
    let level: Int
    let requiredStudyTime: Int
    let characterName: String
    let characterImage: String
    let startOfTheWeek: String
    let startOfTheDay: Int
    let tagId: Int64
}

struct ProfileImageReqDTO: Codable {
    let file: Data
}

struct SearchByNicknameReqDTO: Codable {
    let nickname: String
}

struct SearchByNicknameResDTO: Codable {
    let id: Int64
    let nickname: String
    let profileImage: String?
}

struct ProfileImageResDTO: Codable {
    let id: Int64
    let nickname: String
    let email: String?
    let profileImage: String?
    let level: Int
    let requiredStudyTime: Int
    let characterName: String
    let characterImage: String
    let startOfTheWeek: String
    let startOfTheDay: Int
    let tagId: Int64
}

struct ExistedNicknameResDTO: Codable {
    let exists: Bool
}

struct GetUserResDTO: Codable {
    let id: Int64
    let nickname: String
    let email: String?
    let profileImage: String?
    let level: Int
    let requiredStudyTime: Int
    let characterName: String
    let characterImage: String
    let startOfTheWeek: String
    let startOfTheDay: Int
    let tagId: Int64
}
