//
//  FriendAddDoneView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/15.
//

import SwiftUI

struct FriendAddDoneView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @ObservedObject var viewModel: FriendAddViewModel // 환경 객체로 타이머 뷰 모델을 가져옵니다.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("함께 성장할\n새 친구가 생겼어요!")
                            .lineSpacing(6)
                            .font(.system(size: 24, weight: .semibold))
                        Spacer()
                    }
                    HStack {
                        Text("친구의 프로필에 들러 응원해보세요")
                            .foregroundColor(FancyColor.gray4.color)
                            .padding(.top, 18)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 80)

                Spacer()

                ZStack(alignment: .center) {
                    LottieView(name: "lottie-confetti", currentFrame: 50)
                    if let profileImageUrl = viewModel.friendUser?.profileImage {
                        ProfileImageView(imageURL: profileImageUrl, size: 150)
                    } else {
                        Image("ic_img_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                    }
                    Text(viewModel.friendUser?.nickname ?? "")
                        .padding(.top, 200)
                        .font(.system(size: 22, weight: .semibold))
                    
                }
                .frame(width: 300, height: 300)
                .padding(20)
                
                Spacer()

                if let _ = viewModel.followingFriendUser?.followed {
                    FancyButton(title: "담벼락 보러가기", action: {
                        viewModel.closeSheet()
                        guard let nickname = viewModel.followingFriendUser?.nickname, let userId = viewModel.followingFriendUser?.followId else { return }
                        let userInfo = ["nickname": nickname, "userId": userId] as [String : Any]
                        NotificationCenter.default.post(name: .nextToFriendViewNotification, object: nil, userInfo: userInfo)
                        viewModel.nickname = ""
                    }, style: .constant(.button))
                        .padding(.top, 30)
                }
                FancyButton(title: "계속 친구 추가", action: {
                    self.viewModel.nickname = ""
                    self.presentationMode.wrappedValue.dismiss()
                }, style: .constant(.outline))
                .padding(.top, 12)
            }
            
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    actionSheetManager.hide()
                }) {
                    Image("ic_xmark")
                        .resizable()
                }
                .frame(width: 24, height: 24)
            }
        }
         .padding(30)
        .frame(width: .infinity, height: .infinity)
        .navigationBarHidden(true)
        .onDisappear {
            viewModel.isNavigatingToNextView = false
        }
    }
}
