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
        // Managers
        container.register(AppFlowManager.self) { _ in AppFlowManager() }
        
        container.register(SignUpUserModel.self) { _ in SignUpUserModel() }
        
        // Services
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }

        // View Models
        container.register(ContentViewModel.self) { resolver in ContentViewModel() }
        container.register(SignInViewModel.self) { resolver in SignInViewModel() }
        container.register(SignUpViewModel.self) { resolver in SignUpViewModel(signUpUserModel: resolver.resolve(SignUpUserModel.self) ?? SignUpUserModel() ) }
        container.register(SplashViewModel.self) { resolver in SplashViewModel() }

    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return container.resolve(serviceType)!
    }
}
