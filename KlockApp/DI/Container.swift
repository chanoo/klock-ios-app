//
//  Container.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Swinject

class Container {
    static let shared = Container()
    private let container = Swinject.Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {
//        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
}
