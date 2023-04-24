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
                 hourHandImageName: "img_watch_hand_hour",
                 minuteHandImageName: "img_watch_hand_min",
                 secondHandImageName: "img_watch_hand_sec",
                 clockBackgroundImageName: "img_watch_face1",
                 clockSize: CGSize(width: 300, height: 300)
             )
         }

        // Services
        // Local
        container.register(AccountServiceProtocol.self) { _ in AccountLocalService() }
        container.register(AccountTimerServiceProtocol.self) { _ in AccountTimerLocalService() }
        container.register(MessageServiceProtocol.self) { _ in MessageLocalService() }
        container.register(StudySessionServiceProtocol.self) { _ in StudySessionLocalService() }
        // Remote
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(ChatGPTServiceProtocol.self) { _ in ChatGPTService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }
        // ETC
        container.register(ProximityAndOrientationServiceProtocol.self) { _ in ProximityAndOrientationService() }

        // CharBot Service
        container.register(ChatBotServiceProtocol.self, name: "remote") { _ in ChatBotRemoteService() }
        container.register(ChatBotServiceProtocol.self, name: "local") { _ in ChatBotLocalService() }
        container.register(ChatBotSyncProtocol.self) { resolver in
            guard let chatBotRemoteService = resolver.resolve(ChatBotServiceProtocol.self, name: "remote") as? ChatBotRemoteService,
                  let chatBotLocalService = resolver.resolve(ChatBotServiceProtocol.self, name: "local") as? ChatBotLocalService else {
                fatalError("Failed to resolve ChatBotServiceProtocol instances")
            }

            return ChatBotSync(
                chatBotRemoteService: chatBotRemoteService,
                chatBotLocalService: chatBotLocalService
            )
        }

        // View Models
        container.register(ContentViewModel.self) { _ in ContentViewModel() }
        container.register(SignInViewModel.self) { _ in SignInViewModel() }
        container.register(SignUpViewModel.self) { resolver in
            SignUpViewModel(signUpUserModel: resolver.resolve(SignUpUserModel.self) ?? SignUpUserModel() )
        }
        container.register(SplashViewModel.self) { _ in SplashViewModel() }
        container.register(ChatBotViewModel.self) { resolver in
            return ChatBotViewModel()
        }
        container.register(TimeTimerViewModel.self) { resolver in
            let clockModel = resolver.resolve(ClockModel.self)!
            return TimeTimerViewModel(clockModel: clockModel)
        }
        container.register(CalendarViewModel.self) { _ in CalendarViewModel() }
        container.register(PomodoroTimerViewModel.self) { _ in PomodoroTimerViewModel() }
   }

    func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
        return container.resolve(serviceType, name: name)!
    }

}
