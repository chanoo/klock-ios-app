//
//  FriendDetailView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import Foundation
import Combine
import SwiftUI

struct FriendDetailView: View {
    let friendModel: FriendModel

    var body: some View {
        VStack {
            Text("친구 정보: \(friendModel.name)")
            Text("캐릭터")
            // 캐릭터 이미지나 정보를 추가하세요
        }
        .padding()
        .navigationTitle("\(friendModel.name)의 정보")
    }
}
