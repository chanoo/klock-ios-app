//
//  SignInViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation
import Combine
import FacebookLogin
import AuthenticationServices

class SignInViewModel: NSObject, ObservableObject {
    
    @Published var destination: (Destination, SignUpUserModel)?
    @Published var signUpUserModel: SignUpUserModel

    var cancellableSet: Set<AnyCancellable> = []
    let authenticationService: AuthenticationServiceProtocol
    private let emailValidator = EmailValidator()

    let signInButtonTapped = PassthroughSubject<Void, Never>()
    let signInWithFacebookTapped = PassthroughSubject<Void, Never>()
    let signInWithAppleTapped = PassthroughSubject<Void, Never>()

    init(authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!) {
        self.authenticationService = authenticationService
        self.signUpUserModel = SignUpUserModel()
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
                })
                .store(in: &self!.cancellableSet)
        }
    }

    func signInWithApple() {
        // Implement Apple login
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    func resetDestination() {
        destination = nil
    }

}
