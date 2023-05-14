//
//  SplashViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/08.
//

import Foundation
import Combine
import FacebookLogin
import AuthenticationServices
import Swinject

class SplashViewModel: NSObject, ObservableObject {
    @Published var destination: Destination?
    @Published var navigateToHome = false

    var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()
        setupBindings()
    }

    private func setupBindings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToHome = true
        }
    }

    func resetDestination() {
        destination = nil
        navigateToHome = false
    }
}
