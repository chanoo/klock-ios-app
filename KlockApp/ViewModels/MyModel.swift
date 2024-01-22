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

class AppUsageController: ObservableObject {
    static let shared = AppUsageController()
    let store = ManagedSettingsStore()
    let center = DeviceActivityCenter()
    let schedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59),
        repeats: true
    )
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection

    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()

        // 앱 초기화 시 저장된 설정 불러오기
        loadFromUserDefaults()
    }
    
    func initiateMonitoring() {
        startMonitoring()
        setShieldRestrictions()
    }
    
    func setShieldRestrictions() {
        if #available(iOS 16.0, *) {
            let applications = AppUsageController.shared.selectionToDiscourage
            let exceptions = applications.applicationTokens
            store.shield.applicationCategories = .all(except: exceptions)

            let webDomainTokens = applications.webDomainTokens
            store.shield.webDomainCategories = .all(except: webDomainTokens)

            // Save current selections
            saveToUserDefaults(selection: selectionToDiscourage)
        }
    }

    private func saveToUserDefaults(selection: FamilyActivitySelection) {
        if let encodedData = try? encoder.encode(selection) {
            UserDefaults.standard.set(encodedData, forKey: "familyControlSelections")
        }
    }

    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "familyControlSelections") else {
            print("====> No data saved in the family controls user defaults")
            return
        }
        
        if let selections = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            self.selectionToDiscourage.applicationTokens = selections.applicationTokens
            self.selectionToDiscourage.categoryTokens = selections.categoryTokens
            self.selectionToDiscourage.webDomainTokens = selections.webDomainTokens
        } else {
            self.selectionToDiscourage.applicationTokens = Set()
            self.selectionToDiscourage.categoryTokens = Set()
            self.selectionToDiscourage.webDomainTokens = Set()
        }
    }
    
    private func startMonitoring() {
        if #available(iOS 16.0, *) {
            do {
                try center.startMonitoring(.daily, during: schedule)
            } catch {
                print ("Could not start monitoring \(error)")
            }
        }
    }

    func stopMonitoring() {
        if #available(iOS 16.0, *) {
            store.clearAllSettings()
            center.stopMonitoring()
        } else {
            // Fallback on earlier versions
        }
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}
