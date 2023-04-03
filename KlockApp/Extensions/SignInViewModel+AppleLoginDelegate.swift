//
//  SignInViewModel+AppleLoginDelegate.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import AuthenticationServices
import Alamofire

extension SignInViewModel: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let appleIDTokenData = appleIDCredential.identityToken,
              let appleIDToken = String(data: appleIDTokenData, encoding: .utf8) else {
            print("Error during Apple login")
            return
        }

        // 사용자 이름 가져오기
//        let userIdentifier = appleIDCredential.user
//        let firstName = appleIDCredential.fullName?.givenName
//        let lastName = appleIDCredential.fullName?.familyName

        // 이메일 가져오기 (옵셔널)
//        let email = appleIDCredential.email

        authenticationService.signInWithApple(accessToken: appleIDToken)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    if error.responseCode == 401 {
                        self.destination = .signUp
                    }
                case .finished:
                    break
                }
            }, receiveValue: { user in
                print("User: \(user)")
                self.destination = .home
            })
            .store(in: &cancellableSet)
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error during Apple login: \(error.localizedDescription)")
    }
}
