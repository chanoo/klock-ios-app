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

    @Published var signUpUserModel: SignUpUserModel
    @Published var isNextButtonEnabled = false
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false
    @Published var selectedTagId: Int64?
    @Published var tags: [TagModel] = []

    private let authenticationService: AuthenticationServiceProtocol
    private let tagService: TagServiceProtocol

    var cancellables: Set<AnyCancellable> = []
    var isNextButtonEnabledCancellable: AnyCancellable?

    let nextButtonTapped = PassthroughSubject<Void, Never>()
    let toggleTagSelectionSubject = PassthroughSubject<Int64, Never>()
    let confirmButtonTapped = PassthroughSubject<Void, Never>()
    let fetchTagsSubject = PassthroughSubject<Void, Never>()
    let signUpSuccess = PassthroughSubject<Void, Never>()

    var onUsernameNextButtonTapped: (() -> Void)?
    var onTagsNextButtonTapped: (() -> Void)?
    var onSignUpSuccess: (() -> Void)?

    init(signUpUserModel: SignUpUserModel,
         authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self),
         tagService: TagServiceProtocol = Container.shared.resolve(TagServiceProtocol.self)) {
        self.signUpUserModel = signUpUserModel
        self.authenticationService = authenticationService
        self.tagService = tagService
        super.init()
        setupBindings()

        self.signUpUserModel.tagId = self.selectedTagId ?? 0
    }

    private func setupBindings() {
        setupNextButtonTapped()
        setupIsNextButtonEnabled()
        setupToggleTagSelection()
        setupSignUpButtonTapped()
        setupFetchTags()
    }

    private func setupIsNextButtonEnabled() {
        isNextButtonEnabledCancellable = $signUpUserModel
            .map { $0.username.count >= 2 }
            .assign(to: \.isNextButtonEnabled, on: self)
    }

    private func setupNextButtonTapped() {
        nextButtonTapped
            .sink { [weak self] _ in
                self?.onUsernameNextButtonTapped?()
            }
            .store(in: &cancellables)
    }

    private func setupToggleTagSelection() {
        toggleTagSelectionSubject
             .sink { [weak self] id in
                 if self?.selectedTagId == id {
                     self?.selectedTagId = nil
                 } else {
                     self?.selectedTagId = id
                 }
                 self?.signUpUserModel.tagId = self?.selectedTagId ?? 0
             }
             .store(in: &cancellables)
     }

    // MARK: - Fetch Tags

    private func setupFetchTags() {
        fetchTagsSubject
            .sink { [weak self] _ in
                self?.fetchTags()
            }
            .store(in: &cancellables)
    }

    private func fetchTags() {
        tagService.tags()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching tags: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { tags in
                self.tags = tags.map { TagModel(id: $0.id, name: $0.name) }
            }
            .store(in: &cancellables)
    }

    // MARK: - Confirm Button Action

    private func setupSignUpButtonTapped() {
        confirmButtonTapped
            .sink { [weak self] _ in
                self?.signUp()
            }
            .store(in: &cancellables)
    }

    // MARK: - Sign Up

    func signUp() {

        // print signUpUserModel all properties
        debugPrint("signUpUserModel: ", signUpUserModel.username, signUpUserModel.provider, signUpUserModel.providerUserId, signUpUserModel.tagId)

        authenticationService.signUp(
            username: signUpUserModel.username,
            provider: signUpUserModel.provider,
            providerUserId: signUpUserModel.providerUserId,
            tagId: signUpUserModel.tagId)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error signing up: \(error)")
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self?.onSignUpSuccess?()
                }
            } receiveValue: { user in
                print("User signed up: \(user)")
            }
            .store(in: &cancellables)
    }

}
