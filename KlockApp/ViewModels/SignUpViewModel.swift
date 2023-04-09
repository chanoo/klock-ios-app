//
//  SignUpViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import Foundation
import Combine
import FacebookLogin
import AuthenticationServices
import Swinject

class SignUpViewModel: NSObject, ObservableObject {

    @Published var destination: Destination?
    @Published var signUpUserModel: SignUpUserModel
    @Published var isNextButtonEnabled: Bool = false
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false

    private let authenticationService: AuthenticationServiceProtocol
    var cancellables: Set<AnyCancellable> = []

    let nextButtonTapped = PassthroughSubject<Void, Never>()

    init(signUpUserModel: SignUpUserModel, authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!) {
        self.signUpUserModel = signUpUserModel
        self.authenticationService = authenticationService
        super.init()
        setupBindings()
        
        debugPrint("init SignUpViewModel", signUpUserModel.provider, signUpUserModel.providerUserId)
    }

    private func setupBindings() {
        setupNextButtonTapped()
    }

    private func setupNextButtonTapped() {
        nextButtonTapped
            .sink { [weak self] _ in
                self?.destination = .signUpTag
            }
            .store(in: &cancellables)
    }

    func resetDestination() {
        destination = nil
    }
}
