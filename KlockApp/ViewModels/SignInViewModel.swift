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

class SignInViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {

    @Published var signUpUserModel: SignUpUserModel

    private var cancellableSet: Set<AnyCancellable> = []
    let authenticationService: AuthenticationServiceProtocol

    let signInWithFacebookTapped = PassthroughSubject<Void, Never>()
    let signInWithAppleTapped = PassthroughSubject<Void, Never>()
    let signUpProcess = PassthroughSubject<Void, Never>()
    let signInSuccess = PassthroughSubject<Void, Never>()

    var onSignInWithFacebook: (() -> Void)?
    var onSignUpProcess: (() -> Void)?
    var onSignInSuccess: (() -> Void)?

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
    }

    private func setupSignInWithFacebookTapped() {
        signInWithFacebookTapped
            .sink { [weak self] _ in
                self?.signInWithFacebook()
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

    func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDTokenData = appleIDCredential.identityToken,
              let appleIDToken = String(data: appleIDTokenData, encoding: .utf8) else {
            print("Error during Apple login")
            return
        }

        signUpUserModel.provider = "APPLE"
        signUpUserModel.providerUserId = appleIDCredential.user
        signUpUserModel.firstName = appleIDCredential.fullName?.givenName ?? ""
        signUpUserModel.lastName = appleIDCredential.fullName?.familyName ?? ""
        signUpUserModel.email = appleIDCredential.email ?? ""

        debugPrint("appleIDToken", appleIDToken)

        authenticationService.signInWithApple(accessToken: appleIDToken)
            .sink(receiveCompletion: { completion in
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
            }, receiveValue: { user in
                print("User: \(user)")
                UserDefaults.standard.set(user.token, forKey: "access.token")
                DispatchQueue.main.async {
                    self.onSignInSuccess?()
                }
            })
            .store(in: &cancellableSet)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error during Apple login: \(error.localizedDescription)")
    }
}
