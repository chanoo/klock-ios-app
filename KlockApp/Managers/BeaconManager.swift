//
//  BeaconManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/25.
//

import Foundation
import CoreBluetooth
import CoreLocation
import SwiftUI

class BeaconAdvertiser: NSObject, CBPeripheralManagerDelegate {
    private var peripheralManager: CBPeripheralManager?
    
    override init() {
        super.init()
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertising(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        if peripheralManager?.state == .poweredOn {
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: identifier)
            let beaconPeripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
            peripheralManager?.startAdvertising(((beaconPeripheralData as NSDictionary) as? [String: Any]))
        }
    }
    
    func stopAdvertising() {
        if peripheralManager?.isAdvertising == true {
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Peripheral Manager is switched on.")
        } else {
            print("Peripheral Manager is switched off or not yet ready.")
        }
    }
}

class BeaconScanner: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager: CLLocationManager
    private var beaconIdentityConstraint: CLBeaconIdentityConstraint
    @Published var nearbyBeacons: [CLBeacon] = []

    override init() {
        locationManager = CLLocationManager()
        beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
                                                              major: 1, minor: 456)

        super.init()
        locationManager.delegate = self
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

class BeaconManager: ObservableObject {
    private var beaconAdvertiser: BeaconAdvertiser
    @ObservedObject private var beaconScanner: BeaconScanner
    @Published var nearbyBeacons: [CLBeacon] = []

    init() {
        beaconAdvertiser = BeaconAdvertiser()
        beaconScanner = BeaconScanner()
    }

    func start(uuid: UUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
        beaconAdvertiser.startAdvertising(uuid: uuid, major: major, minor: minor, identifier: identifier)
        beaconScanner.startScanning()
    }

    func stop() {
        beaconAdvertiser.stopAdvertising()
        beaconScanner.stopScanning()
    }
}
