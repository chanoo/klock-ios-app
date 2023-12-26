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
import KeychainAccess
import Alamofire
import Foast

class SignUpViewModel: NSObject, ObservableObject {
    @Published var selectedImage: UIImage?
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
            .filter { $0.nickname.count >= 2 }
            .map { $0.nickname }
            .removeDuplicates()
            .flatMap { nickname in
                return self.userRemoteService.existed(nickname: nickname)
                    .replaceError(with: ExistedNicknameResDTO(exists: false))
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

    // This function simplifies saving user information.
    func saveUser(_ userModel: UserModel) {
        let keychain = Keychain(service: "app.klock.ios")
            .label("app.klock.ios (\(userModel.id)")
            .synchronizable(true)
            .accessibility(.afterFirstUnlock)
        keychain["userId"] = String(userModel.id)
        keychain["token"] = userModel.accessToken
        UserDefaults.standard.set(userModel.id, forKey: "user.id")
        UserDefaults.standard.set(userModel.accessToken, forKey: "access.token")

        // saving user model to user defaults if conversion to json is successful
        if let jsonString = userModel.toJson() {
            UserDefaults.standard.set(jsonString, forKey: "user")
        }
    }

    func signUp() {
        let model = signUpUserModel
        debugPrint("signUpUserModel: \(model)")
        
        authenticationService.signUp(
            nickname: model.nickname,
            provider: model.provider,
            providerUserId: model.providerUserId,
            tagId: model.tagId,
            startOfTheWeek: model.startDay,
            startOfTheDay: model.startTime
        )
        .sink(receiveCompletion: handleSignUpCompletion,
              receiveValue: handleReceivedSignUp)
        .store(in: &cancellables)
    }
    
    func handleSignUpCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            Foast.show(message: error.localizedDescription)
        case .finished:
            break
        }
    }
    
    func handleReceivedSignUp(_ dto: SignUpResDTO) {
        print("User: \(dto)")
        UserDefaults.standard.set(dto.id, forKey: "user.id")
        UserDefaults.standard.set(dto.accessToken, forKey: "access.token")
        
        // 프로필 이미지가 있으면 추가 업로드 시도 아니면 다음
        if (selectedImage != nil) {
            let _selectedImage = selectedImage?.resize(to: CGSize(width: 600, height: 600))
            guard let pngData = _selectedImage?.pngData() else {
                return
            }
            uploadProfileImage(userId: dto.id, imageData: pngData)
        } else {
            self.userRemoteService.get(id: dto.id)
                .sink(receiveCompletion: handleFetchDataCompletion,
                      receiveValue: handleSignUpReceivedData)
                .store(in: &cancellables)
        }
    }
    
    func handleSignUpReceivedData(_ dto: GetUserResDTO) {
        let userModel = UserModel.from(dto: dto)
        userModel.save()
        let keychain = Keychain(service: "app.klock.ios")
            .label("app.klock.ios (\(dto.id)")
            .synchronizable(true)
            .accessibility(.afterFirstUnlock)
        keychain["userId"] = String(userModel.id)
        DispatchQueue.main.async {
            self.onSignUpSuccess?()
        }
    }
    
    func uploadProfileImage(userId: Int64, imageData: Data) {
        let request = ProfileImageReqDTO(file: imageData)
        userRemoteService.profileImage(id: userId, request: request)
            .sink(receiveCompletion: handleFetchDataCompletion,
                  receiveValue: handleReceivedUploadProfileImageDataResponse)
            .store(in: &cancellables)
    }
    
    func handleReceivedUploadProfileImageDataResponse(_ dto: ProfileImageResDTO) {
        var userModel = UserModel.load()
        userModel?.profileImage = dto.profileImage
        userModel?.save()
        DispatchQueue.main.async {
            self.onSignUpSuccess?()
        }
    }

    // 공통 핸들러
    func handleFetchDataCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            Foast.show(message: error.localizedDescription)
        case .finished:
            break
        }
    }
}
