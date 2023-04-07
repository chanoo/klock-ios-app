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
        setupDependencies()
    }

    private func setupDependencies() {
        // Services
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }

        // View Models
        container.register(SignInViewModel.self) { resolver in
            SignInViewModel(authenticationService: resolver.resolve(AuthenticationServiceProtocol.self)!)
        }
        container.register(SignUpViewModel.self) { resolver in
            SignUpViewModel(authenticationService: resolver.resolve(AuthenticationServiceProtocol.self)!)
        }
        container.register(SignUpTagsViewModel.self) { resolver in
            SignUpTagsViewModel(tagService: resolver.resolve(TagServiceProtocol.self)!)
        }
        container.register(SplashViewModel.self) { resolver in
            SplashViewModel()
        }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
}
