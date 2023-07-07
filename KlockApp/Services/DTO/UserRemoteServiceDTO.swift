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
