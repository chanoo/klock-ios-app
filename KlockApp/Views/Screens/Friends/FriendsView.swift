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
    @StateObject private var viewModel = Container.shared.resolve(FriendsViewModel.self)
    @StateObject private var friendAddViewModel = Container.shared.resolve(FriendAddViewModel.self)

    var body: some View {
        List(beaconManager.nearbyBeacons, id: \.uuid) { beacon in
            Text(beacon.uuid.uuidString)
        }
        .navigationBarHidden(false)
        .navigationBarTitle("친구", displayMode: .inline)
        .navigationBarItems(
            leading: NavigationLink(destination: FriendsListView().environmentObject(viewModel), label: {
                Image("ic_sweat")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 8)
            }),
            trailing: Button(action: { viewModel.showActionSheet() }) {
                Image("ic_person_plus")
            }
        )
        .sheet(item: $viewModel.friendAddViewModel.activeSheet) { item in
            viewModel.showAddFriendView(for: item)
        }
        .actionSheet(isPresented: $viewModel.isPresented) { () -> ActionSheet in
            viewModel.friendAddActionSheet()
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
