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
    @Published var isNickNameButtonEnabled = false
    @Published var isStartOfWeekNextButtonEnabled = false
    @Published var isStartOfDayNextButtonEnabled = false
    @Published var isTagNextButtonEnabled = false
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false
    @Published var selectedTagId: Int64?
    @Published var tags: [TagModel] = []
    @Published var error: String?

    private let authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)
    private let tagService: TagServiceProtocol = Container.shared.resolve(TagServiceProtocol.self)
    private let userRemoteService: UserRemoteServiceProtocol = Container.shared.resolve(UserRemoteServiceProtocol.self)

    var cancellables: Set<AnyCancellable> = []

    let toggleTagSelectionSubject = PassthroughSubject<Int64, Never>()
    let confirmButtonTapped = PassthroughSubject<Void, Never>()
    let fetchTagsSubject = PassthroughSubject<Void, Never>()
    let signUpSuccess = PassthroughSubject<Void, Never>()

    var onSignUpSuccess: (() -> Void)?

    init(signUpUserModel: SignUpUserModel) {
        self.signUpUserModel = signUpUserModel
        super.init()
        setupBindings()

        self.signUpUserModel.tagId = self.selectedTagId ?? 0
    }

    private func setupBindings() {
        setupIsNextButtonEnabled()
        setupToggleTagSelection()
        setupSignUpButtonTapped()
        setupFetchTags()
    }

    private func setupIsNextButtonEnabled() {
        $signUpUserModel
            .filter { $0.nickName.count >= 2 }
            .map { $0.nickName }
            .removeDuplicates()
            .flatMap { nickName in
                return self.userRemoteService.existed(nickName: nickName)
                    .replaceError(with: ExistedNickNameResDTO(exists: false))
                    .receive(on: DispatchQueue.main)
            }
            .sink { [weak self] response in
                if response.exists {
                    self?.error = "다른 친구가 이미 사용 중이에요"
                    self?.isNickNameButtonEnabled = false
                } else {
                    self?.error = nil
                    self?.isNickNameButtonEnabled = true
                }
            }
            .store(in: &cancellables)
        
        $signUpUserModel
            .map { $0.startDay == .sunday || $0.startDay == .monday }
            .assign(to: \.isStartOfDayNextButtonEnabled, on: self)
            .store(in: &cancellables)

        $signUpUserModel
            .map { $0.tagId > 0 }
            .assign(to: \.isTagNextButtonEnabled, on: self)
            .store(in: &cancellables)

    }
        
    func setStartDay(day: FirstDayOfWeek) {
        signUpUserModel.startDay = day
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
        debugPrint("signUpUserModel: ", signUpUserModel.nickName, signUpUserModel.provider, signUpUserModel.providerUserId, signUpUserModel.tagId)

        authenticationService.signUp(
            nickName: signUpUserModel.nickName,
            provider: signUpUserModel.provider,
            providerUserId: signUpUserModel.providerUserId,
            tagId: signUpUserModel.tagId,
            startOfTheWeek: signUpUserModel.startDay,
            startOfTheDay: signUpUserModel.startTime
        )
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error signing up: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { user in
                UserDefaults.standard.set(user.accessToken, forKey: "access.token")
                DispatchQueue.main.async {
                    self.onSignUpSuccess?()
                }
                print("User signed up: \(user)")
            }
            .store(in: &cancellables)
    }

}
