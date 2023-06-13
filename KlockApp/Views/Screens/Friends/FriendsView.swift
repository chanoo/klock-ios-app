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

    var body: some View {
        List(beaconManager.nearbyBeacons, id: \.uuid) { beacon in
            Text(beacon.uuid.uuidString)
        }
        .navigationBarHidden(false)
        .navigationBarTitle("친구", displayMode: .inline)
        .navigationBarItems(
            trailing: NavigationLink(destination: FriendAddView(), isActive: $isShowingAddFriend) {
                Button(action: { isShowingAddFriend.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        )

    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
