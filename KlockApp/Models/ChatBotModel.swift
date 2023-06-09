//
//  ChatBotModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/13.
//

import Foundation

struct ChatBotModel: Codable {
    let id: Int64?
    let subject: String
    let title: String
    let name: String
    let chatBotImageUrl: String
    let persona: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case subject
        case title
        case name
        case chatBotImageUrl
        case persona
    }
}
