//
//  FriendsListView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/20.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @StateObject private var viewModel = Container.shared.resolve(FriendsListViewModel.self)

    init() {
        print("FriendsListView init")
    }
    
    var body: some View {
        VStack {
            // Check if the friends list is empty
            if viewModel.isLoading {
                LoadingView()
                    .onAppear{
                        viewModel.fetchFriends()
                    }
            } else if viewModel.friends.isEmpty {
                FriendsListEmptyView()
            } else {
                // ScrollView to show the friends list
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.friends.enumerated()), id: \.element) { index, friendModel in
                            if index == 0 {
                                FirstFriendsRowView(
                                    userId: friendModel.followId,
                                    nickname: friendModel.nickname,
                                    profileImageUrl: friendModel.profileImage,
                                    totalStudyTime: friendModel.totalStudyTime)
                                .environmentObject(actionSheetManager)
                            } else {
                                FriendsRowView(
                                    userId: friendModel.followId,
                                    nickname: friendModel.nickname,
                                    profileImageUrl: friendModel.profileImage,
                                    totalStudyTime: friendModel.totalStudyTime)
                                .environmentObject(actionSheetManager)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("친구")
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButtonView())
    }
}

struct FirstFriendsRowView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    let myUserId = UserModel.load()?.id
    var userId: Int64
    var nickname: String
    var profileImageUrl: String?
    var totalStudyTime: Int64
    var body: some View {
        // myUserId와 userId가 같지 않을 때만 NavigationLink 활성화
        if myUserId != userId {
            NavigationLink(destination: FriendsView(userId: userId, nickname: nickname, following: true)
                            .environmentObject(actionSheetManager)) {
                friendRowContent
            }
        } else {
            // NavigationLink 없이 내용만 표시
            friendRowContent
        }
    }
    
    // 친구 행 내용을 구성하는 공통 뷰
    private var friendRowContent: some View {
        HStack {
            ZStack {
                ZStack(alignment: .center) {
                    ProfileImageWrapperView(profileImageURL: profileImageUrl, profileImageSize: 46)
                    Image("ic_ribbon_one")
                        .resizable()
                        .frame(width: 37, height: 21)
                        .padding(.top, -33)
                }
            }
            Text(nickname)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(FancyColor.text.color)
                .padding(.leading, 10)
            Spacer()
            Text(totalStudyTime > 0 ? TimeUtils.secondsToHMS(seconds: totalStudyTime) : "")
                .font(.system(size: 17, weight: .heavy))
                .foregroundColor(FancyColor.gray4.color)
                .padding(.top, 2)
        }
        .padding()
        .background(FancyColor.listCell.color)
        .cornerRadius(4)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(FancyColor.listCellBorder.color, lineWidth: 0.5)
        )
        .shadow(color: FancyColor.black.color.opacity(0.1), radius: 5, x: 0, y: 0)
    }

}

struct FriendsRowView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    let myUserId = UserModel.load()?.id
    var userId: Int64
    var nickname: String
    var profileImageUrl: String?
    var totalStudyTime: Int64
    var body: some View {
        VStack(spacing: 0) {
            // myUserId와 userId가 같지 않을 때만 NavigationLink 활성화
            if myUserId != userId {
                NavigationLink(destination: FriendsView(userId: userId, nickname: nickname, following: true)
                                .environmentObject(actionSheetManager)) {
                    friendRowContent
                }
            } else {
                // NavigationLink 없이 내용만 표시
                friendRowContent
            }
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.clear)
                .background(FancyColor.listCellUnderline.color)
        }
    }
    
    // 친구 행 내용을 구성하는 공통 뷰
    private var friendRowContent: some View {
        HStack {
            ZStack {
                ZStack(alignment: .center) {
                    ProfileImageWrapperView(profileImageURL: profileImageUrl, profileImageSize: 46)
                }
            }
            Text(nickname)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(FancyColor.text.color)
                .padding(.leading, 10)
            Spacer()
            Text(totalStudyTime > 0 ? TimeUtils.secondsToHMS(seconds: totalStudyTime) : "")
                .font(.system(size: 15, weight: .heavy))
                .foregroundColor(FancyColor.gray4.color)
                .padding(.top, 2)
        }
        .padding()
        .background(FancyColor.listCell.color)  // Apply a background color to HStack
    }
}

struct FriendsListEmptyView: View {
    var body: some View {
        Group {
            Spacer()
            VStack {
                Image("img_three_characters")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 79)
                Text("아직 함께 공부할 친구가 없네요!\n친구와 함께 더 즐겁게 성장해볼까요?")
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundColor(FancyColor.gray4.color)
                    .font(.system(size: 13, weight: .semibold))
                    .padding()
                
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Container.shared.resolve(FriendsViewModel.self)
        FriendsListView()
            .environmentObject(viewModel)
    }
}
