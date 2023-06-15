//
//  FriendsView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/12.
//

import SwiftUI

// 친구 목록 화
struct FriendsView: View {
    @ObservedObject var beaconManager = BeaconManager()
    @State private var isShowingAddFriend = false
    @StateObject private var friendAddViewModel = FriendAddViewModel()

    var body: some View {
        List(beaconManager.nearbyBeacons, id: \.uuid) { beacon in
            Text(beacon.uuid.uuidString)
        }
        .navigationBarHidden(false)
        .navigationBarTitle("친구", displayMode: .inline)
        .navigationBarItems(
            trailing: Button(action: { friendAddViewModel.isShowingAddFriend = true }) {
                Image("ic_person_plus")
            }
            .sheet(isPresented: $friendAddViewModel.isShowingAddFriend) {
                FriendAddView()
                    .environmentObject(friendAddViewModel)
            }
        )
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
