//
//  FriendAddByNearView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI

struct FriendAddByNearView: View {
    @ObservedObject var beaconManager = BeaconManager()
    @ObservedObject var viewModel: FriendAddViewModel

    let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
    let major: UInt16 = 1
    let minor: UInt16 = 456
    let identifier = "성찬우"

    var body: some View {
        List(beaconManager.nearbyBeacons, id: \.uuid) { beacon in
            Text(beacon.uuid.uuidString)
        }
        .navigationBarHidden(false)
        .navigationBarTitle("친구", displayMode: .inline)
        .onAppear {
            beaconManager.start(uuid: uuid, major: major, minor: minor, identifier: identifier)
        }
        .onDisappear {
            beaconManager.stop()
        }
    }
}

struct FriendAddByNearView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var viewModel = Container.shared.resolve(FriendAddViewModel.self)
        FriendAddByNearView(viewModel: viewModel)
    }
}
