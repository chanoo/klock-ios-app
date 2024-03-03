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
    @ObservedObject var friendsViewModel: FriendsViewModel
    @StateObject private var imageViewModel = Container.shared.resolve(ImageViewModel.self)
    @StateObject private var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)

    @State private var isShowingAddFriend = false
    @State private var proxy: ScrollViewProxy?

    var body: some View {
        VStack(spacing: 0) {
            if friendsViewModel.isLoading {
                ChatLoadingView()
                    .onAppear {
                        if let userId = friendsViewModel.friendsViewModelData.userId ?? UserModel.load()?.id {
                            friendsViewModel.fetchUserTrace(userId: userId)
                        }
                    }
            } else if friendsViewModel.groupedUserTraces.isEmpty {
                NoDataView()
            } else {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: [.sectionFooters]) {
                            ForEach(friendsViewModel.groupedUserTraces, id: \.id) { group in
                                Section(footer: Header(title: group.date)) {
                                    ForEach(group.userTraces, id: \.id) { userTrace in
                                        MessageBubbleView(
                                            me: userTrace.writeUserId == friendsViewModel.userModel?.id,
                                            nickname: userTrace.writeNickname,
                                            userTraceType: userTrace.type,
                                            profileImageURL: userTrace.writeUserImage,
                                            content: userTrace.contents,
                                            imageURL: userTrace.contentsImage,
                                            date: userTrace.createdAt.toTimeFormat(),
                                            onDelete: {
                                                friendsViewModel.deleteUserTraceTapped.send(userTrace.id)
                                            }
                                        )
                                        .upsideDown()
                                        .onAppear{
                                            self.proxy = proxy
                                            if let lastId = friendsViewModel.groupedUserTraces.last?.userTraces.last?.id,
                                               lastId == userTrace.id,
                                               let userId = friendsViewModel.friendsViewModelData.userId ?? UserModel.load()?.id {
                                                friendsViewModel.fetchUserTrace(userId: userId)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .upsideDown()
                .onAppear {
                    imageViewModel.checkCameraPermission()
                }
                .onDisappear {
                    friendsViewModel.last = false
                    friendsViewModel.isLoading = true
                    friendsViewModel.page = 0
                    friendsViewModel.groupedUserTraces = []
                }
                .onTapGesture {
                    friendsViewModel.hideKeyboard()
                }
            }
            
            Divider()
            
            ChatInputView(
                text: $friendsViewModel.newMessage,
                dynamicHeight: $friendsViewModel.dynamicHeight,
                isPreparingResponse: $friendsViewModel.isPreparingResponse,
                selectedImage: $imageViewModel.selectedImage,
                cameraPermissionGranted: $imageViewModel.cameraPermissionGranted,
                showingImagePicker: $imageViewModel.showingImagePicker,
                isSendMessage: $friendsViewModel.isSendMessage,
                onSend: { message in
                    let _selectedImage = imageViewModel.selectedImage?.resize(to: CGSize(width: 600, height: 600))
                    friendsViewModel.image = _selectedImage?.pngData()
                    friendsViewModel.contents = message
                    friendsViewModel.sendTapped.send()
                    imageViewModel.selectedImage = nil
                    if let proxy = self.proxy {
                        scrollToLastMessage(with: proxy)
                    }
                }
            )
        }
        .background(FancyColor.chatBotBackground.color)
        .navigationBarTitle(friendsViewModel.friendsViewModelData.nickname ?? "친구", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: naviLeadingItemView,
            trailing: addFriendButtonView
        )
        .sheet(item: $friendAddViewModel.activeSheet) { item in
            friendsViewModel.showAddFriendView(for: item)
        }
    }
    
    private var naviLeadingItemView: some View {
        Group {
            if friendsViewModel.friendsViewModelData.userId == UserModel.load()?.id {
                NavigationLink(destination: FriendsListView()
                                .environmentObject(friendsViewModel)
                                .environmentObject(actionSheetManager)
                                .onAppear(perform: {
                                    // 필요한 작업 수행
                                })) {
                    Image("ic_sweats")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 8)
                }
            } else {
                BackButtonView() // 여기서 BackButtonView는 사용자 정의 뷰입니다.
            }
        }
    }
    
    private var addFriendButtonView: some View {
        Group {
            if friendsViewModel.friendsViewModelData.userId == UserModel.load()?.id {
                Button(action: {
                    friendsViewModel.hideKeyboard()
                    actionSheetManager.actionSheet = CustomActionSheetView(
                        title: "친구 추가",
                        message: "나와 같이 성장해 나갈 친구와 같이 공부하세요.",
                        actionButtons: [
                            FancyButton(title: "QR코드 스캔", action: {
                                withAnimation(.spring()) {
                                    actionSheetManager.isPresented = false
                                }
                                friendAddViewModel.activeSheet = .qrcode
                            }, style: .constant(.outline)),
                            FancyButton(title: "닉네임 친구추가", action: {
                                withAnimation(.spring()) {
                                    actionSheetManager.isPresented = false
                                }
                                friendAddViewModel.activeSheet = .nickname
                            }, style: .constant(.outline)),
        //                        ActionButton(title: "주변탐색 친구추가", action: {
        //                            withAnimation(.spring()) {
        //                                actionSheetManager.isPresented = false
        //                            }
        //                            friendAddViewModel.activeSheet = .nearby
        //                        }),
                        ],
                        cancelButton: FancyButton(title: "취소", action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                        }, style: .constant(.text))
                    )
                    withAnimation(.spring()) {
                        actionSheetManager.isPresented = true
                    }
                }) {
                    Image("ic_person_plus")
                }
            }
        }
    }
    
    private func scrollToLastMessage(with proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            if let lastId = friendsViewModel.groupedUserTraces.first?.userTraces.first?.id {
                print("## lastId", lastId)
                withAnimation {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }
}

struct NoDataView: View {
    
    var body: some View {
        Spacer() // Pushes content to the center vertically

        VStack {
            Image("img_chat_characters")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 79)
            Text("친구와 함께 소통하며 공부할 수 있어요!\n지금 친구를 추가해볼까요?")
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .foregroundColor(FancyColor.gray4.color)
                .font(.system(size: 13, weight: .semibold))
                .padding()
            
        }
        .frame(maxWidth: .infinity) // Ensure it takes up the full width

        Spacer() // Pushes content to the center vertically
    }
}

struct Header: View {
    var title: String

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .padding([.top, .bottom], 8) // 텍스트 상하 패딩
                    .padding([.leading, .trailing], 10) // 텍스트 좌우 패딩
                    .background(FancyColor.gray9.color.opacity(0.5)) // 반투명 흰색 배경 추가
                    .cornerRadius(6) // 모서리를 둥글게 처리
                    .foregroundColor(.white) // 텍스트 색상을 흰색으로 설정
                Spacer()
            }
        }
        .upsideDown()
        .padding([.top, .bottom], 8) // VStack에 상단 패딩 추가
    }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = FriendsViewModel(nickname: "친구", userId: 151)
//        let friendAddViewModel = FriendAddViewModel()
//        FriendsView(friendsViewModel: friendsViewModel)
//            .environmentObject(viewModel)
//            .environmentObject(friendAddViewModel)
//    }
//}
