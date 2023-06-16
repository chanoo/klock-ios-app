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
    
    func addFriendByQRCode() {
        // QR 코드로 친구를 추가하는 로직을 여기에 구현하십시오.
        print("Add friend by QR code")
        self.isPresented = false
    }
    
    func addFriendByID() {
        // 아이디로 친구를 추가하는 로직을 여기에 구현하십시오.
        print("Add friend by ID")
        self.isPresented = false
    }
    
    func addFriendByNearbySearch() {
        // 주변 탐색으로 친구를 추가하는 로직을 여기에 구현하십시오.
        print("Add friend by Nearby Search")
        self.isPresented = false
    }
    
    func showAddFriendView(for item: SheetType) -> some View {
        switch item {
        case .qrcode:
            return AnyView(FriendAddView().environmentObject(friendAddViewModel))
        case .nickname:
            return AnyView(Text("Add Friend By ID")) // 또는 AddFriendByIdView()
        case .nearby:
            return AnyView(Text("Add Friend By Nearby Search")) // 또는 AddFriendByNearbySearchView()
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
