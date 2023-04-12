//
//  FriendsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

// 친구 목록 화면
struct FriendsView: View {
    @StateObject var friendsViewModel = FriendsViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(friendsViewModel.friends) { friend in
                    NavigationLink(destination: FriendDetailView(friendModel: friend)) {
                        HStack {
                            Text(friend.name)
                            Spacer()
                            if friend.isOnline {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 10, height: 10)
                            } else {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 10, height: 10)
                            }
                        }
                    }
                }
            }
            .navigationTitle("친구 목록")
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
