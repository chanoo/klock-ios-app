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
    let id: Int64
    let accessToken: String?
    let refreshToken: String?
    var nickname: String
    var profileImage: String?
    let tagId: Int64
    let startOfTheWeek: String
    let startOfTheDay: Int
    let totalStudyTime: Int

    enum CodingKeys: String, CodingKey {
        case id
        case accessToken
        case refreshToken
        case nickname
        case profileImage
        case tagId
        case startOfTheWeek
        case startOfTheDay
        case totalStudyTime
    }

    static func from(dto: SignUpResDTO) -> UserModel {
        return UserModel(
            id: dto.id,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            nickname: dto.nickname,
            profileImage: nil,
            tagId: dto.tagId,
            startOfTheWeek: dto.startOfTheWeek,
            startOfTheDay: dto.startOfTheDay,
            totalStudyTime: 0
        )
    }
    
    static func from(dto: GetUserResDTO) -> UserModel {
        return UserModel(
            id: dto.id,
            accessToken: nil,
            refreshToken: nil,
            nickname: dto.nickname,
            profileImage: dto.profileImage,
            tagId: dto.tagId,
            startOfTheWeek: dto.startOfTheWeek,
            startOfTheDay: dto.startOfTheDay,
            totalStudyTime: 0
        )
    }

    func toJson() -> String? {
         let encoder = JSONEncoder()
         encoder.outputFormatting = .prettyPrinted // if you want pretty print, otherwise remove this line
         do {
             let jsonData = try encoder.encode(self)
             if let jsonString = String(data: jsonData, encoding: .utf8) {
                 return jsonString
             }
         } catch {
             print("Error converting UserModel to JSON: \(error)")
         }
         return nil
     }

    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }

    static func load() -> UserModel? {
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserModel.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
    }
}
