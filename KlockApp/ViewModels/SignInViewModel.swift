//
//  SignInViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    private var cancellableSet: Set<AnyCancellable> = []
    private let authenticationService = AuthenticationService()

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
}
