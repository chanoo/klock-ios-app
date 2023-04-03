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

class SignUpViewModel: NSObject, ObservableObject {
    @Published var nickname: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var showStudyTagsView = false
    @Published var destination: Destination?

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

    func signUp() {
        // 회원 가입 처리 로직을 여기에 구현하세요.
        // 예를 들어, authenticationService.signUp() 함수를 호출하고 선택한 태그와 닉네임을 전달할 수 있습니다.
    }

    func resetDestination() {
        destination = nil
    }
}
