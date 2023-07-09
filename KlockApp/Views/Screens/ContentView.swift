//
//  ContentView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: Color?
    
    init(backgroundColor: Color?) {
        self.backgroundColor = backgroundColor
        let coloredAppearance = UINavigationBarAppearance()
        if let backgroundColor = backgroundColor {
            coloredAppearance.configureWithTransparentBackground()
            coloredAppearance.backgroundColor = backgroundColor.uiColor().withAlphaComponent(1)
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
    @StateObject var actionSheetManager = ActionSheetManager()
    @StateObject var userViewModel = UserViewModel()
    @StateObject var model = MyModel.shared

    var body: some View {
        ZStack {
            NavigationView {
                viewModel.currentView
                    .environmentObject(actionSheetManager)
                    .environmentObject(userViewModel)
                    .environmentObject(model)
            }
        }
        .modifier(CustomActionSheetModifier(isPresented: $actionSheetManager.isPresented) {
            AnyView(actionSheetManager.actionSheet)
        })
        .modifier(NavigationBarModifier(backgroundColor: FancyColor.navigationBar.color))
        .onReceive(appFlowManager.navigateToDestination) { _ in
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
        .onAppear {
            viewModel.updateCurrentView(appFlowManager: appFlowManager)
        }
    }
}
