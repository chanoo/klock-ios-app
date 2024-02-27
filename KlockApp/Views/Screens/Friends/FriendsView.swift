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
    @StateObject private var viewModel = Container.shared.resolve(FriendsViewModel.self)
    @StateObject private var imageViewModel = Container.shared.resolve(ImageViewModel.self)
    @StateObject private var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)

    @State private var isShowingAddFriend = false
    @State private var proxy: ScrollViewProxy?

    private let tabBarManager = Container.shared.resolve(TabBarManager.self)

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.groupedUserTraces.isEmpty {
                NoDataView()
                    .onAppear {
                        viewModel.fetchUserTrace()
                    }
            } else {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: [.sectionFooters]) {
                            ForEach(viewModel.groupedUserTraces, id: \.id) { group in
                                Section(footer: Header(title: group.date)) {
                                    ForEach(group.userTraces, id: \.id) { userTrace in
                                        MessageBubbleView(
                                            me: userTrace.writeUserId == viewModel.userModel?.id,
                                            nickname: userTrace.writeNickname,
                                            userTraceType: userTrace.type,
                                            profileImageURL: userTrace.writeUserImage,
                                            content: userTrace.contents,
                                            imageURL: userTrace.contentsImage,
                                            date: userTrace.createdAt.toTimeFormat(),
                                            onDelete: {
                                                viewModel.deleteUserTraceTapped.send(userTrace.id)
                                            }
                                        )
                                        .upsideDown()
                                        .onAppear{
                                            self.proxy = proxy
                                            if let lastId = viewModel.groupedUserTraces.last?.userTraces.last?.id {
                                                if lastId == userTrace.id {
                                                    viewModel.fetchUserTrace()
                                                }
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
                .onTapGesture {
                    viewModel.hideKeyboard()
                    tabBarManager.show()
                }
            }
            
            Divider()
            
            ChatInputView(
                text: $viewModel.newMessage,
                dynamicHeight: $viewModel.dynamicHeight,
                isPreparingResponse: $viewModel.isPreparingResponse,
                selectedImage: $imageViewModel.selectedImage,
                cameraPermissionGranted: $imageViewModel.cameraPermissionGranted,
                showingImagePicker: $imageViewModel.showingImagePicker,
                isSendMessage: $viewModel.isSendMessage,
                onSend: { message in
                    let _selectedImage = imageViewModel.selectedImage?.resize(to: CGSize(width: 600, height: 600))
                    viewModel.image = _selectedImage?.pngData()
                    viewModel.contents = message
                    viewModel.sendTapped.send()
                    imageViewModel.selectedImage = nil
                    if let proxy = self.proxy {
                        scrollToLastMessage(with: proxy)
                    }
                }
            ).environmentObject(tabBarManager) // ChatInputView에 TabBarManager 전달
        }
        .background(FancyColor.chatBotBackground.color)
        .navigationBarTitle("친구", displayMode: .inline)
        .navigationBarItems(
            leading: NavigationLink(destination: FriendsListView().environmentObject(viewModel).onAppear(perform: {
                tabBarManager.show()
            }), label: {
                Image("ic_sweats")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 8)
            }),
            trailing: Button(action: {
                viewModel.hideKeyboard()
                tabBarManager.show()
                actionSheetManager.actionSheet = CustomActionSheetView(
                    title: "친구 추가",
                    message: "나와 같이 성장해 나갈 친구와 같이 공부하세요.",
                    actionButtons: [
                        ActionButton(title: "QR코드 스캔", action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                            friendAddViewModel.activeSheet = .qrcode
                        }),
                        ActionButton(title: "닉네임 친구추가", action: {
                            withAnimation(.spring()) {
                                actionSheetManager.isPresented = false
                            }
                            friendAddViewModel.activeSheet = .nickname
                        }),
//                        ActionButton(title: "주변탐색 친구추가", action: {
//                            withAnimation(.spring()) {
//                                actionSheetManager.isPresented = false
//                            }
//                            friendAddViewModel.activeSheet = .nearby
//                        }),
                    ],
                    cancelButton: ActionButton(title: "취소", action: {
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
    
    private func scrollToLastMessage(with proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            if let lastId = viewModel.groupedUserTraces.first?.userTraces.first?.id {
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

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendsViewModel()
        let friendAddViewModel = FriendAddViewModel()
        FriendsView()
            .environmentObject(viewModel)
            .environmentObject(friendAddViewModel)
    }
}
