//
// ChatGPTResponse.swift
// KlockApp
//
// Created by 성찬우 on 2023/04/12.
//

import Foundation

struct ChatGPTResponse: Codable {
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
