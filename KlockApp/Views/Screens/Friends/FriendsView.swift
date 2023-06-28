//
//  FriendsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

// 친구 목록 화
struct FriendsView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @State private var isShowingAddFriend = false
    @StateObject private var viewModel = Container.shared.resolve(FriendsViewModel.self)
    @StateObject private var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)
    @State private var dynamicHeight: CGFloat = 20 // 높이 초기값
    let maxHeight: CGFloat = 70 // 최대 높이 (1줄당 대략 20~25 정도를 예상하고 세팅)

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) { // 스크롤바 숨김
                    ScrollViewReader { _ in
                        LazyVStack(spacing: 4) {
                            ForEach(viewModel.activities, id: \.id) { activity in
                                ActivityBubble(activityModel: activity, isPreparingResponse: $viewModel.isPreparingResponse)
                            }
                        }
                    }
                }

                // ChatGPTView의 body 내에서 HStack 부분
                HStack(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 0) {
                        ZStack(alignment: .bottomTrailing) {
                            TextView(text: $viewModel.newMessage, dynamicHeight: $dynamicHeight, maxHeight: maxHeight)
                                .frame(height: dynamicHeight)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(0)
                                .padding(.leading, 6)
                                .padding(.trailing, 25)
                                .foregroundColor(FancyColor.primary.color)
                                .background(FancyColor.chatBotInput.color)
                                .cornerRadius(4)
                        }
                        .padding(1)
                        .background(FancyColor.chatBotInputOutline.color)
                        .cornerRadius(4)

                        Button(action: {
                        }) {
                            Image("ic_circle_arrow_up")
                                .foregroundColor(FancyColor.chatBotSendButton.color)
                        }
                        .padding(1)
                        .padding(.top, 2)
                        .frame(height: 40)
                        .frame(width: 40)
                        .disabled(viewModel.isPreparingResponse)
                    }
                    .padding(.top, 5)
                    .padding(.leading, 14)
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
                }
                .background(FancyColor.chatBotInputBackground.color)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(FancyColor.background.color)
        .navigationBarTitle("친구", displayMode: .inline)
        .navigationBarItems(
            leading: NavigationLink(destination: FriendsListView().environmentObject(viewModel), label: {
                Image("ic_sweats")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 8)
            }),
            trailing: Button(action: {
                actionSheetManager.actionSheet = CustomActionSheetView(
                    title: "친구 추가",
                    message: "나와 같이 성장해 나갈 친구와 같이 공부하세요.",
                    actionButtons: [
                        ActionButton(label: Text("QR코드 스캔"), action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                            friendAddViewModel.activeSheet = .qrcode
                        }),
                        ActionButton(label: Text("닉네임 친구추가"), action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                            friendAddViewModel.activeSheet = .nickname
                        }),
                        ActionButton(label: Text("주변탐색 친구추가"), action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                            friendAddViewModel.activeSheet = .nearby
                        }),
                    ],
                    cancelButton: ActionButton(label: Text("취소"), action: {
                        withAnimation(.spring()) {
                            actionSheetManager.isPresented = false
                        }
                    })
                )
                withAnimation(.spring()) {
                    actionSheetManager.isPresented = true
                }
            }) {
                Image("ic_person_plus")
            }
        )
        .sheet(item: $friendAddViewModel.activeSheet) { item in
            viewModel.showAddFriendView(for: item)
        }
    }
}

struct ActivityBubble: View {
    @ObservedObject var activityModel: ActivityModel
    @Binding var isPreparingResponse: Bool
    @Environment(\.colorScheme) var colorScheme // 이 부분을 추가하세요.
    @State private var scale: CGFloat = 1

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 8) {
                if activityModel.userId == 2 {
                    Image("img_profile2")
                        .padding(.leading, 8)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(activityModel.nickname)
                            .font(.system(size: 15))
                            .foregroundColor(FancyColor.subtext.color)
                            .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            ZStack(alignment: .bottomTrailing) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        self.scale = 2
                                        activityModel.likeCount += 1
                                    }
                                    withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                                        self.scale = activityModel.likeCount >= 10 ? 1.5 : 1
                                    }
                                } label: {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(activityModel.message)
                                            .font(.system(size: 15))
                                            .padding(12)
                                        if let attachment = activityModel.attachment {
                                            Image(attachment)
                                                .resizable()
                                                .frame(width: .infinity)
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(6)
                                                .padding(.leading, 14)
                                                .padding(.trailing, 14)
                                                .padding(.bottom, 14)
                                        }
                                    }
                                }
                                .background(FancyColor.chatBotBubbleMe.color)
                                .clipShape(RoundedCorners(tl: 0, tr: 4, bl: 4, br: 4))
                                .foregroundColor(FancyColor.chatbotBubbleTextMe.color)
                                if activityModel.likeCount > 0 {
                                    Image("ic_love")
                                        .foregroundColor(FancyColor.red.color)
                                        .padding(.bottom, -8)
                                        .padding(.trailing, -8)
                                        .scaleEffect(scale)
                                }
                            }
                            .zIndex(10)
                            Text(TimeUtils.formattedDateString(from: activityModel.createdAt, format: "a h:mm"))
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.subtext.color)
                                .zIndex(9)
                        }
                    }
                    Spacer()
                } else {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(activityModel.nickname)
                            .font(.system(size: 13))
                            .foregroundColor(FancyColor.subtext.color)
                            .padding(.bottom, 4)
                        HStack(alignment: .bottom) {
                            Text(TimeUtils.formattedDateString(from: activityModel.createdAt, format: "a h:mm"))
                                .font(.system(size: 13))
                                .foregroundColor(FancyColor.subtext.color)
                                .zIndex(9)
                            ZStack(alignment: .bottomLeading) {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        self.scale = 2
                                        activityModel.likeCount += 1
                                    }
                                    withAnimation(.easeInOut(duration: 0.5).delay(0.5)) {
                                        self.scale = activityModel.likeCount >= 10 ? 1.5 : 1
                                    }
                                } label: {
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(activityModel.message)
                                            .font(.system(size: 15))
                                            .padding(12)
                                        if let attachment = activityModel.attachment {
                                            Image(attachment)
                                                .resizable()
                                                .frame(width: .infinity)
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(6)
                                                .padding(.leading, 14)
                                                .padding(.trailing, 14)
                                                .padding(.bottom, 14)
                                        }
                                    }
                                }
                                .background(FancyColor.chatBotBubble.color)
                                .clipShape(RoundedCorners(tl: 4, tr: 0, bl: 4, br: 4))
                                .foregroundColor(FancyColor.chatbotBubbleText.color)
                                if activityModel.likeCount > 0 {
                                    Image("ic_love")
                                        .foregroundColor(FancyColor.red.color)
                                        .padding(.bottom, -8)
                                        .padding(.leading, -8)
                                        .scaleEffect(scale)
                                }
                            }
                            .zIndex(10)
                        }

                    }
                    Image("img_profile2")
                        .padding(.trailing, 8)
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 4)
            .padding(.leading, activityModel.userId == 2 ? 8 : 16)
            .padding(.trailing, activityModel.userId == 2 ? 16 : 8)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        let friendAddViewModel = FriendAddViewModel()
        FriendsView()
            .environmentObject(viewModel)
            .environmentObject(friendAddViewModel)
    }
}
