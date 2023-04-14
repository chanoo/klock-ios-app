//
//  ChatBotModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/13.
//

import Foundation

struct ChatBotModel: Identifiable, Codable {
    let id: Int64?
    let subject: String
    let title: String
    let name: String
    let persona: String
}
