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

struct FriendRelationFollowQRCodeReqDTO: Hashable, Codable {
    let followData: String
    let encryptedKey: String
    
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
    
    static func decode(from jsonString: String) -> FriendRelationFollowQRCodeReqDTO? {
        let decoder = JSONDecoder()
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        do {
            let decodedObject = try decoder.decode(FriendRelationFollowQRCodeReqDTO.self, from: data)
            return decodedObject
        } catch DecodingError.dataCorrupted {
            return nil
        } catch {
            return nil
        }
    }
}

struct FriendRelationFollowQRCodeResDTO: Codable, Hashable {
    let id: Int64
    let userId: Int64
    let followId: Int64
    let followed: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case followId
        case followed
        case createdAt
    }
}

struct FriendRelationFollowReqDTO: Codable {
    let followId: Int64
}

struct FriendRelationFollowResDTO: Codable {
    let id: Int64
    let userId: Int64
    let followId: Int64
    let followed: Bool
    let profileImage: String?
    let nickname: String
    let createdAt: String
}

struct FriendRelationUnfollowReqDTO: Codable {
    let followId: Int64
}
