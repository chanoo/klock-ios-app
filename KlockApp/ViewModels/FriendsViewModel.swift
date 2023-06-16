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
