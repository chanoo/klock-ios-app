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
    @ObservedObject var viewModel: FriendsViewModel
    @StateObject var imageViewModel = Container.shared.resolve(ImageViewModel.self)

    @State private var proxy: ScrollViewProxy?
    
    init(userId: Int64, nickname: String, following: Bool) {
        print("FriendsView init")
        self.viewModel = FriendsViewModel(nickname: nickname, userId: userId, following: following)
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ChatLoadingView()
                    .onAppear {
                        viewModel.fetchUserTrace(userId: viewModel.userId)
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
                                            heartCount: userTrace.heartCount,
                                            onHeart: {
                                                
                                            },
                                            onDelete: {
                                                viewModel.deleteUserTraceTapped.send(userTrace.id)
                                            }
                                        )
                                        .upsideDown()
                                        .onAppear{
                                            self.proxy = proxy
                                            if let lastId = viewModel.groupedUserTraces.last?.userTraces.last?.id,
                                               lastId == userTrace.id {
                                                viewModel.fetchUserTrace(userId: viewModel.userId)
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
                text: $viewModel.newMessage,
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
            
        }
        .background(FancyColor.chatBotBackground.color)
        .navigationBarTitle(viewModel.nickname, displayMode: .inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(
            leading: leadingItemView,
            trailing: trailingItemView
        )
    }
    
    private var leadingItemView: some View {
        BackButtonView()
    }
    
    private var trailingItemView: some View {
        FancyButton(
            title: viewModel.followTitle,
            action: {
                viewModel.unfollowButtonTapped.send(!viewModel.following)
            },
            size: .small,
            style: .constant(.outline))
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

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewModel = FriendsViewModel(nickname: "친구", userId: 151)
//        let friendAddViewModel = FriendAddViewModel()
//        FriendsView(friendsViewModel: friendsViewModel)
//            .environmentObject(viewModel)
//            .environmentObject(friendAddViewModel)
//    }
//}
