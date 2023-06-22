//
//  ContentView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor?
    
    init(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        if let backgroundColor = backgroundColor {
            coloredAppearance.configureWithTransparentBackground()
            coloredAppearance.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        } else {
            coloredAppearance.configureWithTransparentBackground()
        }
        coloredAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
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
        .modifier(NavigationBarModifier(backgroundColor: .white))
        .onReceive(appFlowManager.navigateToDestination) { _ in
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
        .onAppear {
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
    }
}
