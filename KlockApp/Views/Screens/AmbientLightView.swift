//
//  AmbientLightView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/18.
//

import SwiftUI

struct AmbientLightView: View {
    @StateObject private var viewModel = AmbientLightViewModel(ambientLightService: AmbientLightService())

    var body: some View {
        VStack {
            if viewModel.isDark {
                Text("어두운 환경 감지")
                    .onAppear {
                        NotificationManager.sendLocalNotification()
                    }
            } else {
                Text("밝은 환경")
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }
}
