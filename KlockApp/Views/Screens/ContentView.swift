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
    @State private var activeDestination: Destination? = .signUp
    
    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentView
            }
        }
        .onReceive(appFlowManager.navigateToDestination) { destination in
            activeDestination = destination
            updateCurrentView(for: destination)
        }
    }
    
    private func viewForDestination(_ destination: Destination?) -> AnyView {
        switch destination {
        case .home:
            return AnyView(HomeView().environmentObject(appFlowManager))
        case .signIn:
            return AnyView(SignInView(viewModel: Container.shared.resolve(SignInViewModel.self))
                .environmentObject(appFlowManager))
        default:
            return AnyView(SignInView(viewModel: Container.shared.resolve(SignInViewModel.self))
                .environmentObject(appFlowManager))
        }
    }

    private func updateCurrentView(for destination: Destination?) {
        viewModel.currentView = viewForDestination(destination)
    }

}
