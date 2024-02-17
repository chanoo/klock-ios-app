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
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var isShowingAddFriend = false
    @StateObject private var viewModel = Container.shared.resolve(FriendsViewModel.self)
    @StateObject private var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)
    @State private var dynamicHeight: CGFloat = 20 // 높이 초기값

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    if viewModel.groupedUserTraces.isEmpty {
                        Spacer() // Pushes content to the center vertically

                        VStack {
                            Image("img_three_characters")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 79)
                            Text("아직 함께 공부한 기록이 없네요!!\n공부를 시작해서 나를 성장시켜볼까요?")
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .foregroundColor(FancyColor.gray4.color)
                                .font(.system(size: 13, weight: .semibold))
                                .padding()
                            
                        }
                        .frame(maxWidth: .infinity) // Ensure it takes up the full width

                        Spacer() // Pushes content to the center vertically
                    } else {
                        ScrollView(showsIndicators: false) { // 스크롤바 숨김
                            ScrollViewReader { _ in
                                LazyVStack(spacing: 4) {
                                    ForEach(viewModel.groupedUserTraces, id: \.id) { group in
                                        ForEach(group.userTraces, id: \.id) { userTrace in
                                            MessageBubbleView(
                                                me: userTrace.writeUserId == viewModel.userModel?.id, // 이 예제에서는 사용자 ID가 2일 경우 자신으로 간주
                                                nickname: userTrace.writeNickname, // 실제 닉네임 정보가 필요. 여기서는 예시 값을 사용
                                                userTraceType: userTrace.type,
                                                profileImageURL: userTrace.writeUserImage,
                                                content: userTrace.contents,
                                                imageURL: userTrace.contentsImage,
                                                date: userTrace.createdAt.toTimeFormat() // 날짜 정보 전달
                                            )
                                        }
                                        Header(title: group.date)
                                    }
                                }
                            }
                        }
                        .rotationEffect(.degrees(180), anchor: .center)
                    }
                }
                
                // ChatGPTView의 body 내에서 HStack 부분
                ChatInputView(text: $viewModel.newMessage, dynamicHeight: $dynamicHeight, isPreparingResponse: $viewModel.isPreparingResponse)
            }
            .onTapGesture {
                viewModel.hideKeyboard()
                tabBarManager.show()
            }
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
        .onAppear(perform: {
            viewModel.fetchUserTrace()
        })
    }
}

struct Header: View {
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .rotationEffect(.degrees(180), anchor: .center) // 텍스트를 180도 회전
                .padding([.top, .bottom], 8) // 텍스트 상하 패딩
                .padding([.leading, .trailing], 10) // 텍스트 좌우 패딩
                .background(FancyColor.gray9.color.opacity(0.5)) // 반투명 흰색 배경 추가
                .cornerRadius(6) // 모서리를 둥글게 처리
                .foregroundColor(.white) // 텍스트 색상을 흰색으로 설정
        }
        .padding(.bottom, 10) // VStack에 상단 패딩 추가
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
