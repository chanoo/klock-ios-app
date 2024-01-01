//
//  SignInViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import SwiftUI
import Combine
import AuthenticationServices
import Alamofire
import FacebookLogin
import KeychainAccess
import KakaoSDKUser

class SignInViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {

    @Published var signUpUserModel: SignUpUserModel

    private var cancellableSet: Set<AnyCancellable> = []
    let authenticationService: AuthenticationServiceProtocol

    let signInWithFacebookTapped = PassthroughSubject<Void, Never>()
    let signInWithAppleTapped = PassthroughSubject<Void, Never>()
    let signInWithKakaoTapped = PassthroughSubject<Void, Never>()
    let signUpProcess = PassthroughSubject<Void, Never>()
    let signInSuccess = PassthroughSubject<Void, Never>()

    var onSignInWithFacebook: (() -> Void)?
    var onSignUpProcess: (() -> Void)?
    var onSignInSuccess: (() -> Void)?
    
    private let userRemoteService: UserRemoteServiceProtocol = Container.shared.resolve(UserRemoteServiceProtocol.self)

    init(authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)) {
        self.signUpUserModel = SignUpUserModel()
        self.authenticationService = authenticationService
        super.init()
        setupBindings()

        debugPrint("init SignInViewModel")
    }

    private func setupBindings() {
        setupSignInWithFacebookTapped()
        setupSignInWithAppleTapped()
        setupSignInWithKakaoTapped()
    }

    private func setupSignInWithFacebookTapped() {
        signInWithFacebookTapped
            .sink { [weak self] _ in
                self?.signInWithFacebook()
            }
            .store(in: &cancellableSet)
    }
    
    private func setupSignInWithKakaoTapped() {
        signInWithKakaoTapped
            .sink { [weak self] _ in
                self?.signInWithKakao()
            }
            .store(in: &cancellableSet)
    }

    private func setupSignInWithAppleTapped() {
        signInWithAppleTapped
            .sink { [weak self] _ in
                self?.signInWithApple()
            }
            .store(in: &cancellableSet)
    }

    func signInWithFacebook() {
        // Implement Facebook login
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { [weak self] (result, error) in
            if let error = error {
                print("Error during Facebook login: \(error.localizedDescription)")
                return
            }

            guard let result = result, !result.isCancelled, let accessToken = AccessToken.current?.tokenString else {
                print("Facebook login cancelled")
                return
            }

            self?.authenticationService.signInWithFacebook(accessToken: accessToken)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { user in
                    print("User: \(user)")
                    DispatchQueue.main.async {
                        self?.onSignInWithFacebook?()
                    }
                })
                .store(in: &self!.cancellableSet)
        }
    }
    
    func signInWithKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("me() success.")
                            
                            //do something
                            if let user = user, let userId = user.id {
                                let userIdString = String(userId)
                                self.signUpUserModel.provider = "KAKAO"
                                self.signUpUserModel.providerUserId = userIdString
                                self.handleSocialLogin("KAKAO", userIdString)
                            }
                        }
                    }
               }
            }
        }
    }

    func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func handleAppleIDCredential(_ credential: ASAuthorizationAppleIDCredential) {
        guard let appleIDTokenData = credential.identityToken,
              let appleIDToken = String(data: appleIDTokenData, encoding: .utf8) else {
            print("Error during Apple login")
            return
        }

        fillSignUpUserModel(with: credential)
        debugPrint("appleIDToken", appleIDToken)
        handleSignInWithAppleToken(appleIDToken)
    }

    func fillSignUpUserModel(with credential: ASAuthorizationAppleIDCredential) {
        signUpUserModel.provider = "APPLE"
        signUpUserModel.providerUserId = credential.user
        signUpUserModel.firstName = credential.fullName?.givenName ?? ""
        signUpUserModel.lastName = credential.fullName?.familyName ?? ""
        signUpUserModel.email = credential.email ?? ""
    }
    
    func handleSignInWithAppleToken(_ token: String) {
        authenticationService.signInWithApple(accessToken: token)
            .sink(receiveCompletion: handleAuthenticationCompletion,
                  receiveValue: handleReceivedUser)
            .store(in: &cancellableSet)
    }

    func handleSocialLogin(_ provider: String, _ providerUserId: String) {
        authenticationService.socialLogin(provider: provider, providerUserId: providerUserId)
            .sink(receiveCompletion: handleAuthenticationCompletion,
                  receiveValue: handleReceivedUser)
            .store(in: &cancellableSet)
    }

    func handleAuthenticationCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            if error.responseCode == 401 {
                DispatchQueue.main.async {
                    self.onSignUpProcess?()
                }
            }
        case .finished:
            break
        }
    }

    func handleReceivedUser(_ user: SocialLoginResDTO) {
        print("User: \(user)")
        UserDefaults.standard.set(user.userId, forKey: "user.id")
        UserDefaults.standard.set(user.token, forKey: "access.token")
        UserDefaults.standard.set(user.publicKey, forKey: "public.key")
        fetchUserRemoteData(user.userId)
    }

    func fetchUserRemoteData(_ id: Int64) {
        self.userRemoteService.get(id: id)
            .sink(receiveCompletion: handleFetchDataCompletion,
                  receiveValue: handleReceivedData)
            .store(in: &self.cancellableSet)
    }

    func handleFetchDataCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            if error.responseCode == 401 {
                DispatchQueue.main.async {
                    self.onSignUpProcess?()
                }
            }
        case .finished:
            break
        }
    }

    func handleReceivedData(_ dto: GetUserResDTO) {
        let userModel = UserModel.from(dto: dto)
        userModel.save()
        let keychain = Keychain(service: "app.klock.ios")
            .label("app.klock.ios (\(dto.id)")
            .synchronizable(true)
            .accessibility(.afterFirstUnlock)
        keychain["userId"] = String(userModel.id)
        DispatchQueue.main.async {
            self.onSignInSuccess?()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleIDCredential(appleIDCredential)
        } else {
            print("Error during Apple login")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error during Apple login: \(error.localizedDescription)")
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel() }
    }
}
