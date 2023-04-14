//
//  ChatBotDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/14.
//

import Foundation

struct ChatBotResDTO: Codable {
    let id: Int64
    let subject: String
    let name: String
    let title: String
    let persona: String
}
