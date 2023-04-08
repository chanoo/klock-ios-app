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
    
    @Published var signUpUserModel: SignUpUserModel
    @Published var showStudyTagsView = false
    @Published var selectedTagId: Int64?
    @Published var tags: [TagModel] = []

    @Published var destination: Destination?

    var cancellableSet: Set<AnyCancellable> = []
    private let tagService: TagServiceProtocol
    private let authenticationService: AuthenticationServiceProtocol

    let confirmButtonTapped = PassthroughSubject<Void, Never>()

    init(
        signUpUserModel: SignUpUserModel,
        authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!,
        tagService: TagServiceProtocol = Container.shared.resolve(TagServiceProtocol.self)!) {
        self.signUpUserModel = signUpUserModel
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
    
    // 태그 선택시 호출되는 메서드
    func toggleTagSelection(id: Int64) {
        if selectedTagId == id {
            selectedTagId = nil
        } else {
            selectedTagId = id
        }
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
                self.tags = tags.map { TagModel(id: $0.id, name: $0.name) }
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
        authenticationService.signUp(username: signUpUserModel.firstName, provider: signUpUserModel.provider, providerUserId: signUpUserModel.providerUserId, tagId: signUpUserModel.tagId)
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
