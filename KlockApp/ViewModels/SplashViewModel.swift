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
    
    var cancellables: Set<AnyCancellable> = []

    let nextButtonTapped = PassthroughSubject<Void, Never>()

    override init() {
        super.init()
        setupBindings()
    }

    private func setupBindings() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
             self.destination = .home
         }
    }

    func resetDestination() {
        destination = nil
    }
}
