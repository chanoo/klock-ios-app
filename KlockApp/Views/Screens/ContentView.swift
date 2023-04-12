//
//  ContentView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @EnvironmentObject var appFlowManager: AppFlowManager

    var body: some View {
        NavigationView {
            viewModel.currentView
        }
        .onReceive(appFlowManager.navigateToDestination) { _ in
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
        .onAppear {
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
    }
}
