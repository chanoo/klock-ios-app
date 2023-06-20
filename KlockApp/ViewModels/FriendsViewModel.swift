//
//  FriendsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import Combine

class FriendsViewModel: NSObject, ObservableObject {
    @Published var isPresented = false
    @Published var friendAddViewModel = FriendAddViewModel()
    
    let friends: [UserModel] = [
        UserModel(id: 1, email: nil, hashedPassword: nil, username: "날으는호랑이", profileImage: nil, totalStudyTime: 200, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 2, email: nil, hashedPassword: nil, username: "여유로운쿼카", profileImage: nil, totalStudyTime: 180, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 3, email: nil, hashedPassword: nil, username: "열정적인두루미", profileImage: nil, totalStudyTime: 100, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 4, email: nil, hashedPassword: nil, username: "뀨처돌이", profileImage: nil, totalStudyTime: 100, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date())

    ]

    func showActionSheet() {
        self.isPresented = true
    }
        
    func showAddFriendView(for item: SheetType) -> some View {
        switch item {
        case .qrcode:
            return AnyView(FriendAddByQRCodeView().environmentObject(friendAddViewModel))
        case .nickname:
            return AnyView(FriendAddByNicknameView().environmentObject(friendAddViewModel))
        case .nearby:
            return AnyView(FriendAddByNearView().environmentObject(friendAddViewModel))
        case .none:
            return AnyView(EmptyView())
        }
    }
    
    func friendAddActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("친구 추가 방식을 선택하세요"),
            message: Text("어떤 방식으로 친구를 추가하시겠습니까?"),
            buttons: [
                .default(Text("QR코드 스캔"), action: {
                    self.friendAddViewModel.activeSheet = .qrcode
                }),
                .default(Text("닉네임 친구추가"), action: {
                    self.friendAddViewModel.activeSheet = .nickname
                }),
                .default(Text("주변탐색 친구추가"), action: {
                    self.friendAddViewModel.activeSheet = .nearby
                }),
                .cancel()
            ]
        )
    }
}
