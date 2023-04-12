//
//  FriendModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Foundation

struct FriendModel: Identifiable {
    let id = UUID()
    let name: String
    let isOnline: Bool
}
