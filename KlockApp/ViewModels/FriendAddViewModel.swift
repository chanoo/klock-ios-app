//
//  FriendAddViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI
import Combine
import CoreLocation

enum ActiveView {
    case qrCode
    case nickname
}

class FriendAddViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var beaconIdentityConstraint: CLBeaconIdentityConstraint
    @Published var nearbyBeacons: [CLBeacon] = []
    @Published var friends = [
        FriendModel(name: "Alice", isOnline: true),
        FriendModel(name: "Bob", isOnline: false),
        FriendModel(name: "Charlie", isOnline: true)
    ]
    @Published var scanResult: ScanResult?
    @Published var activeView: ActiveView = .qrCode

    override init() {
        locationManager = CLLocationManager()
        beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(),
                                                              major: 1, minor: 456)

        super.init()
        locationManager.delegate = self
    }

    func updateScanResult(_ result: ScanResult) {
        scanResult = result
    }

    func startScanning() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }

    func stopScanning() {
        locationManager.stopRangingBeacons(satisfying: beaconIdentityConstraint)
    }

    @available(iOS 13.0, *)
    func locationManager(_ manager: CLLocationManager,
                         didRange beacons: [CLBeacon],
                         satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        nearbyBeacons = beacons
    }
}
