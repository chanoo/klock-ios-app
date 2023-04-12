//
//  ContentViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

//
//  ContentViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var currentView: AnyView
    private let authService: AuthenticationServiceProtocol

    init(authService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)) {
        self.authService = authService
        self.currentView = AnyView(EmptyView())
    }

    func updateCurrentView(appFlowManager: AppFlowManager) {
        if authService.isLoggedIn() {
            self.currentView = AnyView(HomeView()
                .environmentObject(appFlowManager))
        } else {
            let signInViewModel = Container.shared.resolve(SignInViewModel.self)
            self.currentView = AnyView(SignInView()
                .environmentObject(appFlowManager)
                .environmentObject(signInViewModel))
        }
    }
}
