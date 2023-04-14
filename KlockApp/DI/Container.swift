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
        container.register(ChatGPTServiceProtocol.self) { _ in ChatGPTService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }
        container.register(ChatBotServiceProtocol.self) { _ in ChatBotService() }

        // View Models
        container.register(ContentViewModel.self) { _ in ContentViewModel() }
        container.register(SignInViewModel.self) { _ in SignInViewModel() }
        container.register(SignUpViewModel.self) { resolver in SignUpViewModel(signUpUserModel: resolver.resolve(SignUpUserModel.self) ?? SignUpUserModel() ) }
        container.register(SplashViewModel.self) { _ in SplashViewModel() }
        container.register(ChatBotViewModel.self) { _ in ChatBotViewModel() }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return container.resolve(serviceType)!
    }
}
