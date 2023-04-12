//
//  ContentView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import SwiftUI

struct NavigationBarColorModifier: ViewModifier {
    var backgroundColor: UIColor

    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    func body(content: Content) -> some View {
        content
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @EnvironmentObject var appFlowManager: AppFlowManager

    var body: some View {
        NavigationView {
            viewModel.currentView
        }
        .navigationViewStyle(.stack)
        .onReceive(appFlowManager.navigateToDestination) { _ in
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
        .onAppear {
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
    }
}
