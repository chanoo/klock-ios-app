//
//  MyModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/09.
//

import Foundation
import DeviceActivity
import ManagedSettings
import MobileCoreServices
import UIKit
import FamilyControls

class MyModel: ObservableObject {
    static let shared = MyModel()
    let store = ManagedSettingsStore()
    let center = DeviceActivityCenter()
    let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59),
        repeats: true
    )
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection

    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    func initiateMonitoring() {
        startMonitoring()
        setShieldRestrictions()
    }
    
    func setShieldRestrictions() {
        let applications = MyModel.shared.selectionToDiscourage
        let exceptions = applications.applicationTokens
        store.shield.applicationCategories = .all(except:exceptions)
    }
    
    private func startMonitoring() {
        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print ("Could not start monitoring \(error)")
        }
    }

    func stopMonitoring() {
        center.stopMonitoring()
        store.clearAllSettings()
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

class MySchedule {
    static public func setSchedule() {
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: MyModel.shared.selectionToEncourage.applicationTokens,
                threshold: DateComponents(minute: 5)
            )
        ]

        print("Setting schedule...")
        print("Hour is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)
        
        do {
            print("Try to start monitoring...")
            try MyModel.shared.center.startMonitoring(.daily, during: MyModel.shared.schedule, events: events)
        } catch {
            print("Error monitoring schedule: ", error)
        }
    }
}
