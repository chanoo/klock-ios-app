//
//  FriendsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import Combine

class FriendsViewModel: ObservableObject {
    @Published var friends = [
        FriendModel(name: "Alice", isOnline: true),
        FriendModel(name: "Bob", isOnline: false),
        FriendModel(name: "Charlie", isOnline: true)
    ]
}
