//
//  FriendsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI
import Combine

class FriendsViewModel: NSObject, ObservableObject {
    @Published var newMessage: String = ""
    @Published var isPresented = false
    @Published var friendAddViewModel = FriendAddViewModel()
    @Published var isPreparingResponse: Bool = false

    let friends: [UserModel] = [
        UserModel(id: 1, email: nil, hashedPassword: nil, username: "날으는호랑이", profileImage: nil, totalStudyTime: 200, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 2, email: nil, hashedPassword: nil, username: "여유로운쿼카", profileImage: nil, totalStudyTime: 180, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 3, email: nil, hashedPassword: nil, username: "열정적인두루미", profileImage: nil, totalStudyTime: 100, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date()),
        UserModel(id: 4, email: nil, hashedPassword: nil, username: "뀨처돌이", profileImage: nil, totalStudyTime: 100, accountLevelId: 1, role: .user, active: true, createdAt: Date(), updatedAt: Date())

    ]
    
    let activities: [ActivityModel] = [
        ActivityModel(id: 1, message: "국어 공부를 시작했어요!🔥", userId: 2, nickname: "뀨처돌이", profileImage: "", attachment: nil, likeCount: 0, createdAt: TimeUtils.dateFromString(dateString: "20230622132310", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 2, message: "아직 다 못외움.. 진짜 왤케 많냐 ㅜㅜ", userId: 1, nickname: "날으는호랑이", profileImage: "", attachment: nil, likeCount: 1, createdAt: TimeUtils.dateFromString(dateString: "20230622133110", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 3, message: "나도 아직 ㅜ 홧팅하자!!!!!!🔥", userId: 3, nickname: "열정적인두루미", profileImage: "", attachment: nil, likeCount: 0, createdAt: TimeUtils.dateFromString(dateString: "20230622141110", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 4, message: "어제보다 오늘 하나 더 알면 성공!", userId: 4, nickname: "여유로운쿼카", profileImage: "", attachment: "img_sample_study1", likeCount: 0, createdAt: TimeUtils.dateFromString(dateString: "20230622141133", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 5, message: "영어 공부를 시작했어요!🔥", userId: 2, nickname: "뀨처돌이", profileImage: "", attachment: nil, likeCount: 0, createdAt: TimeUtils.dateFromString(dateString: "20230622141133", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 6, message: "국어 공부를 시작했어요!🔥", userId: 2, nickname: "뀨처돌이", profileImage: "", attachment: nil, likeCount: 1, createdAt: TimeUtils.dateFromString(dateString: "20230622141133", format: "yyyyMMddHHmmss")!),
        ActivityModel(id: 7, message: "오늘 공부 인증!! 아자아자!!!🔥", userId: 2, nickname: "뀨처돌이", profileImage: "", attachment: "img_sample_study2", likeCount: 0, createdAt: TimeUtils.dateFromString(dateString: "20230622141133", format: "yyyyMMddHHmmss")!),
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
