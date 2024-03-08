//
//  MyWallView.swift
//  KlockApp
//
//  Created by 성찬우 on 3/7/24.
//

import SwiftUI

struct MyWallView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @StateObject var viewModel = Container.shared.resolve(MyWallViewModel.self)
    @StateObject var imageViewModel = Container.shared.resolve(ImageViewModel.self)
    @StateObject var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)

    @State private var proxy: ScrollViewProxy?
    
    init() {
        print("MyWallView init")
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ChatLoadingView()
                    .onAppear {
                        if let userId = UserModel.load()?.id {
                            viewModel.fetchUserTrace(userId: userId)
                        }
                    }
            } else if viewModel.groupedUserTraces.isEmpty {
                MyWallNoDataView()
            } else {
                ScrollView {
                    ScrollViewReader { proxy in
                        LazyVStack(pinnedViews: [.sectionFooters]) {
                            ForEach(viewModel.groupedUserTraces, id: \.id) { group in
                                Section(footer: MyWallListHeader(title: group.date)) {
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
                                            if let lastId = viewModel.groupedUserTraces.last?.userTraces.last?.id,
                                               lastId == userTrace.id,
                                               let userId = UserModel.load()?.id {
                                                viewModel.fetchUserTrace(userId: userId)
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
                }
            }
            
            Divider()
            
            ChatInputView(
                text: $viewModel.contents,
                dynamicHeight: $viewModel.dynamicHeight,
                isPreparingResponse: $viewModel.isPreparingResponse,
                selectedImage: $imageViewModel.selectedImage,
                cameraPermissionGranted: $imageViewModel.cameraPermissionGranted,
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
            )
            
//            NavigationStack {
//                List {
//                    NavigationLink("Mint", value: Color.mint)
//                    NavigationLink("Pink", value: Color.pink)
//                    NavigationLink("Teal", value: Color.teal)
//                }
//                .navigationDestination(for: Color.self) { color in
//                    ColorDetail(color: color)
//                }
//                .navigationTitle("Colors")
//            }
//
//            
            
            NavigationLink(
                destination: LazyView(FriendsView(userId: viewModel.userId ?? 0, nickname: viewModel.nickname ?? "친구", following: true)
                    .environmentObject(actionSheetManager)
                    .onAppear {
                        viewModel.viewDidAppear() // FriendsView가 화면에 나타날 때 호출
                    }
                ),
                isActive: $viewModel.isNavigatingToFriendView) {
                    EmptyView()
                }
        }
        .background(FancyColor.chatBotBackground.color)
        .navigationBarTitle("담벼락", displayMode: .inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: leadingItemView,
            trailing: trailingItemView
        )
        .sheet(item: $friendAddViewModel.activeSheet) { item in
            viewModel.showAddFriendView(for: item, viewModel: friendAddViewModel)
        }
    }
    
    private var leadingItemView: some View {
        // 친구 목록
        NavigationLink(
            destination: LazyView(FriendsListView()
                .environmentObject(actionSheetManager)
                .onAppear {
                    viewModel.viewDidAppear() // FriendsView가 화면에 나타날 때 호출
                }
            ),
            isActive: $viewModel.isNavigatingToFriendListView) {
                Button {
                    viewModel.isNavigatingToFriendListView = true
                } label: {
                    Image("ic_sweats")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .padding(.leading, 8)
                }
            }
    }
    
    private var trailingItemView: some View {
        Button(action: {
            viewModel.hideKeyboard()
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
