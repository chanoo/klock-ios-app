//
//  Container.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import Swinject
import UIKit

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

        // Models
        container.register(SignUpUserModel.self) { _ in SignUpUserModel() }
        container.register(ClockModel.self) { _ in
             ClockModel(
                 hourHandLength: 150,
                 minuteHandLength: 200,
                 secondHandLength: 250,
                 hourHandThickness: 4,
                 minuteHandThickness: 3,
                 secondHandThickness: 2,
                 hourHandImageName: "img_watch_hand_hour",
                 minuteHandImageName: "img_watch_hand_min",
                 secondHandImageName: "img_watch_hand_sec",
                 clockBackgroundImageName: "img_watch_face1",
                 clockSize: CGSize(width: 300, height: 300)
             )
         }

        // Services
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(ChatGPTServiceProtocol.self) { _ in ChatGPTService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }
        container.register(ChatBotServiceProtocol.self) { _ in ChatBotService() }
        container.register(MessageServiceProtocol.self) { _ in MessageService() }
        container.register(StudySessionServiceProtocol.self) { _ in StudySessionService() }
        container.register(ProximityAndOrientationServiceProtocol.self) { _ in ProximityAndOrientationService() }

        // View Models
        container.register(ContentViewModel.self) { _ in ContentViewModel() }
        container.register(SignInViewModel.self) { _ in SignInViewModel() }
        container.register(SignUpViewModel.self) { resolver in SignUpViewModel(signUpUserModel: resolver.resolve(SignUpUserModel.self) ?? SignUpUserModel() ) }
        container.register(SplashViewModel.self) { _ in SplashViewModel() }
        container.register(ChatBotViewModel.self) { _ in ChatBotViewModel() }
        container.register(ClockViewModel.self) { resolver in
            let clockModel = resolver.resolve(ClockModel.self)!
            return ClockViewModel(clockModel: clockModel)
        }
        container.register(CalendarViewModel.self) { _ in CalendarViewModel() }
   }

    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        return container.resolve(serviceType)!
    }
}
