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
    @Published var nickname: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var showStudyTagsView = false
    @Published var destination: Destination?
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false

    private let authenticationService: AuthenticationServiceProtocol
    var cancellables: Set<AnyCancellable> = []

    let nextButtonTapped = PassthroughSubject<Void, Never>()

    init(authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!) {
        self.authenticationService = authenticationService
        super.init()
        setupBindings()
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
