//
//  FriendsListView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/20.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @StateObject private var viewModel = Container.shared.resolve(FriendsViewModel.self)

    var body: some View {
        VStack {
            // Check if the friends list is empty
            if viewModel.friends.isEmpty {
                Spacer() // Pushes content to the center vertically

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
                .frame(maxWidth: .infinity) // Ensure it takes up the full width

                Spacer() // Pushes content to the center vertically
            } else {
                // ScrollView to show the friends list
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(viewModel.friends.enumerated()), id: \.element) { index, friendModel in
                            if index == 0 {
                                FirstFriendsRowView(friendModel: friendModel)
                                    .environmentObject(actionSheetManager)
                            } else {
                                FriendsRowView(friendModel: friendModel)
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
        .onAppear(perform: {
            viewModel.fetchFriends()
        })
    }
}

struct FirstFriendsRowView: View {
    var friendModel: FriendRelationFetchResDTO
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @ObservedObject var friendsViewModel: FriendsViewModel

    // `friendModel`을 매개변수로 받는 init 메소드 추가
    init(friendModel: FriendRelationFetchResDTO) {
        self.friendModel = friendModel
        let data = FriendsViewModelData(nickname: friendModel.nickname, userId: friendModel.followId, following: true)
        self._friendsViewModel = ObservedObject(initialValue: FriendsViewModel(data: data))
    }

    var body: some View {
        NavigationLink(
            destination: FriendsView(friendsViewModel: friendsViewModel)
                .environmentObject(actionSheetManager)) {
            HStack {
                ZStack {
                    ZStack(alignment: .center) {
                        Image("img_profile2")
                            .resizable()
                            .frame(width: 46, height: 46)
                        Image("ic_ribbon_one")
                            .resizable()
                            .frame(width: 37, height: 21)
                            .padding(.top, -33)
                        Circle()
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(FancyColor.black.color, lineWidth: 1))
                            .padding(.top, 33)
                            .padding(.leading, 33)
                            .foregroundColor(FancyColor.primary.color)
                    }
                }
                Text(friendModel.nickname)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(FancyColor.text.color)
                    .padding(.leading, 10)
                Spacer()
                Text("\(TimeUtils.secondsToHMS(seconds: friendModel.totalStudyTime))")
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
}

struct FriendsRowView: View {
    var friendModel: FriendRelationFetchResDTO
    @EnvironmentObject var actionSheetManager: ActionSheetManager
    @ObservedObject var friendsViewModel: FriendsViewModel

    // `friendModel`을 매개변수로 받는 init 메소드 추가
    init(friendModel: FriendRelationFetchResDTO) {
        self.friendModel = friendModel
        let data = FriendsViewModelData(nickname: friendModel.nickname, userId: friendModel.followId, following: true)
        self._friendsViewModel = ObservedObject(initialValue: FriendsViewModel(data: data))
    }

    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(
                destination: FriendsView(friendsViewModel: friendsViewModel)
                    .environmentObject(actionSheetManager)) {
                HStack {
                    ZStack {
                        ZStack(alignment: .center) {
                            Image("img_profile2")
                                .resizable()
                                .frame(width: 46, height: 46)
                            Circle()
                                .frame(width: 10, height: 10)
                                .overlay(Circle().stroke(FancyColor.black.color, lineWidth: 1))
                                .padding(.top, 33)
                                .padding(.leading, 33)
                                .foregroundColor(FancyColor.primary.color)
                        }
                    }
                    Text(friendModel.nickname)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(FancyColor.text.color)
                        .padding(.leading, 10)
                    Spacer()
                    Text("\(TimeUtils.secondsToHMS(seconds: friendModel.totalStudyTime))")
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(FancyColor.gray4.color)
                        .padding(.top, 2)
                }
                .padding()
                .background(FancyColor.listCell.color)  // Apply a background color to HStack
            }
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.clear)
                .background(FancyColor.listCellUnderline.color)
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
