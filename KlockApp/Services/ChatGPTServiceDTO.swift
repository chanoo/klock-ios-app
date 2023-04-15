//
//  ChatGPTServiceDTO.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/15.
//

import Foundation

struct ChatCompletionsReqDTO: Codable {
    let model: String
    let messages: [[String: String]]
    let stream: Bool

    init(messages: [MessageModel]) {
        self.model = "gpt-3.5-turbo"
        self.messages = messages.map { ["role": $0.role, "content": $0.content] }
        self.stream = true
    }
}

struct ChatCompletionsResDTO: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [ChatGPTChoice]

    struct ChatGPTChoice: Codable {
        let delta: ChatGPTDelta
        let index: Int
        let finish_reason: String?

        struct ChatGPTDelta: Codable {
            let content: String?
        }
    }
}
