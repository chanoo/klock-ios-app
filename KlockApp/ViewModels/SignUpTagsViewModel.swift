//
//  SignUpTagsViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/03.
//

import Foundation
import Combine
import FacebookLogin
import Swinject

class SignUpTagsViewModel: NSObject, ObservableObject {
    @Published var nickname: String = ""
    @Published var provider: String = ""
    @Published var providerUserId: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var showStudyTagsView = false
    @Published var tags: [String] = []

    @Published var destination: Destination?

    var cancellableSet: Set<AnyCancellable> = []
    private let tagService: TagServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol

    let confirmButtonTapped = PassthroughSubject<Void, Never>()

    init(
        authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!,
        tagService: TagServiceProtocol = Container.shared.resolve(TagServiceProtocol.self)!) {
        self.authenticationService = authenticationService
        self.tagService = tagService
        super.init()
        setupBindings()
        fetchTags()
    }

    // MARK: - Bindings

    private func setupBindings() {
        setupConfirmButtonTapped()
    }

    // MARK: - Fetch Tags

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
                self.tags = tags.map { $0.name }
            }
            .store(in: &cancellableSet)
    }

    // MARK: - Confirm Button Action

    private func setupConfirmButtonTapped() {
        confirmButtonTapped
            .sink { [weak self] _ in
                self?.signUp()
            }
            .store(in: &cancellableSet)
    }

    // MARK: - Sign Up

    func signUp() {
        // Implement the sign-up process here.
        // For example, call the authenticationService.signUp() function and pass the selected tags and nickname.
        authenticationService.signUp(username: nickname, provider: provider, providerUserId: providerUserId, tagId: nil)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error signing up: \(error)")
                    self?.destination = .splash
                case .finished:
                    break
                }
            } receiveValue: { user in
                print("User signed up: \(user)")
            }
            .store(in: &cancellableSet)
    }
    
    func resetDestination() {
        destination = nil
    }
}
