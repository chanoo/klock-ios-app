//
//  Message.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Foundation

struct MessageModel: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
}
