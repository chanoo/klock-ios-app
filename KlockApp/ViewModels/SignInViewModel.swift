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
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var destination: Destination?
    @Published var provier: SocialProvider?
    @Published var provierUserID: String?

    var cancellableSet: Set<AnyCancellable> = []
    let authenticationService: AuthenticationServiceProtocol
    private let emailValidator = EmailValidator()

    let signInButtonTapped = PassthroughSubject<Void, Never>()
    let signInWithFacebookTapped = PassthroughSubject<Void, Never>()
    let signInWithAppleTapped = PassthroughSubject<Void, Never>()

    init(authenticationService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)!) {
        self.authenticationService = authenticationService
        super.init()
        setupBindings()
    }

    private func setupBindings() {
        setupEmailValidation()
        setupSignInButtonTapped()
        setupSignInWithFacebookTapped()
        setupSignInWithAppleTapped()
    }

    private func setupEmailValidation() {
        $email
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.email.count >= 5 {
                    self.validateEmail()
                } else {
                    self.errorMessage = nil
                }
            }
            .store(in: &cancellableSet)
    }

    private func setupSignInButtonTapped() {
        signInButtonTapped
            .sink { [weak self] _ in
                self?.signIn()
            }
            .store(in: &cancellableSet)
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

    private func validateEmail() {
        if !emailValidator.isValid(email) {
            errorMessage = "올바른 이메일 주소를 입력해 주세요."
        } else {
            errorMessage = nil
        }
    }

    func signIn() {
        authenticationService.signIn(email: email, password: password)
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
