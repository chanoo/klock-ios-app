//
//  Container.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Swinject

class Container {
    static let shared = Container()

    private let container: Swinject.Container

    private init() {
        container = Swinject.Container()
        setup()
    }

    private func setup() {
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(SignInViewModel.self) { reg in
            SignInViewModel(authenticationService: reg.resolve(AuthenticationServiceProtocol.self)!)
        }
        container.register(SignUpViewModel.self) { reg in
            SignUpViewModel(authenticationService: reg.resolve(AuthenticationServiceProtocol.self)!)
        }
        container.register(SignUpTagsViewModel.self) { reg in
            SignUpTagsViewModel(authenticationService: reg.resolve(AuthenticationServiceProtocol.self)!)
        }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
}
