//
//  Message.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Foundation

struct MessageModel: Identifiable, Codable {
    let id: UUID
    let content: String
    let chatBotID: Int64?
    let role: String
    
    init(content: String, role: String, chatBotID: Int64?) {
        self.id = UUID()
        self.content = content
        self.chatBotID = chatBotID
        self.role = role
    }
    
    var isUser: Bool {
        return role == "user"
    }
}
