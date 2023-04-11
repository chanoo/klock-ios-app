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

    private var cancellableSet: Set<AnyCancellable> = []
    private let authService: AuthenticationServiceProtocol

    init(authService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)) {
        self.authService = authService
        
        if authService.isLoggedIn() {
            self.currentView = AnyView(HomeView())
        } else {
            self.currentView = AnyView(SignInView(viewModel: Container.shared.resolve(SignInViewModel.self)))
        }
    }
}
