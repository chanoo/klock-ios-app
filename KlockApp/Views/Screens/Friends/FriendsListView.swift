//
//  FriendsListView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/20.
//

import SwiftUI

struct FriendsListView: View {
    @EnvironmentObject var viewModel: FriendsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(viewModel.friends.enumerated()), id: \.element) { index, friendModel in
                    if index == 0 {
                        FirstFriendsRowView(userModel: friendModel)
                    } else {
                        FriendsRowView(userModel: friendModel)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("친구")
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButtonView())
    }
}

struct FirstFriendsRowView: View {
    var userModel: UserModel
    var body: some View {
        NavigationLink(destination: FriendsView()) {
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
                VStack(alignment: .leading, spacing: 0) {
                    Text(userModel.username)
                        .font(.headline)
                        .foregroundColor(FancyColor.text.color)
                    Text("\(TimeUtils.secondsToHMS(seconds: userModel.totalStudyTime))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(FancyColor.gray4.color)
                        .padding(.top, 2)
                }
                .padding(.leading, 10)

                Spacer()
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
    var userModel: UserModel
    var body: some View {
        VStack(spacing: 0) {
            NavigationLink(destination: FriendsView()) {
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
                    VStack(alignment: .leading, spacing: 0) {
                        Text(userModel.username)
                            .font(.headline)
                            .foregroundColor(FancyColor.text.color)
                        Text("\(TimeUtils.secondsToHMS(seconds: userModel.totalStudyTime))")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(FancyColor.gray4.color)
                            .padding(.top, 2)
                    }
                    .padding(.leading, 10)
                    Spacer()
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
