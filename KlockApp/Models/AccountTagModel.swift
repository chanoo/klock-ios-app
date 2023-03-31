//
//  AccountTag.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import Foundation

struct AccountTagModel: Codable {
    let id: Int64?
    let accountId: Int64
    let tagId: Int64

    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case tagId = "tag_id"
    }
}
