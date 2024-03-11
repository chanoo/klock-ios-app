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
        container.register(TimerManager.self) { _ in TimerManager() }
        container.register(TabBarManager.self) { _ in TabBarManager() }

        // Models
        container.register(SignUpUserModel.self) { _ in SignUpUserModel() }
        container.register(AnalogClockModel.self) { _ in
            AnalogClockModel(
                hourHandImageName: "img_watch_hand_hour",
                minuteHandImageName: "img_watch_hand_min",
                secondHandImageName: "img_watch_hand_sec",
                clockBackgroundImageName: "img_watch_face1",
                clockSize: CGSize(width: 300, height: 300),
                hourHandColor: .black,
                minuteHandColor: .black,
                secondHandColor: .pink,
                outlineInColor: .white.opacity(0.8),
                outlineOutColor: .white.opacity(0.6)
            )
        }
        
        // Services
        // Local
        container.register(AccountLocalServiceProtocol.self) { _ in AccountLocalService() }
        container.register(AccountTimerServiceProtocol.self) { _ in AccountTimerLocalService() }
        container.register(MessageServiceProtocol.self) { _ in MessageLocalService() }
        // Remote
        container.register(AuthenticationServiceProtocol.self) { _ in AuthenticationService() }
        container.register(ChatGPTServiceProtocol.self) { _ in ChatGPTService() }
        container.register(TagServiceProtocol.self) { _ in TagService() }
        container.register(TimerRemoteServiceProtocol.self) { _ in TimerRemoteService() }
        container.register(FocusTimerRemoteServiceProtocol.self) { _ in FocusTimerRemoteService() }
        container.register(PomodoroTimerRemoteServiceProtocol.self) { _ in PomodoroTimerRemoteService() }
        container.register(ExamTimerRemoteServiceProtocol.self) { _ in ExamTimerRemoteService() }
        container.register(StudySessionRemoteServiceProtocol.self) { _ in StudySessionRemoteService() }
        container.register(AutoTimerRemoteServiceProtocol.self) { _ in AutoTimerRemoteService() }
        container.register(UserRemoteServiceProtocol.self) { _ in UserRemoteService() }
        container.register(FriendRelationServiceProtocol.self) { _ in FriendRelationService() }
        container.register(UserTraceRemoteServiceProtocol.self) { _ in UserTraceRemoteService() }
        
        // ETC
        container.register(ProximityAndOrientationServiceProtocol.self) { _ in ProximityAndOrientationService() }

        // CharBot Service
        container.register(ChatBotRemoteServiceProtocol.self) { _ in ChatBotRemoteService() }
        container.register(ChatBotLocalServiceProtocol.self) { _ in ChatBotLocalService() }
        container.register(ChatBotSyncProtocol.self) { resolver in
            guard let chatBotRemoteService = resolver.resolve(ChatBotRemoteServiceProtocol.self) as? ChatBotRemoteService,
                  let chatBotLocalService = resolver.resolve(ChatBotLocalServiceProtocol.self) as? ChatBotLocalService else {
                fatalError("Failed to resolve ChatBotServiceProtocol instances")
            }

            return ChatBotSync(
                chatBotRemoteService: chatBotRemoteService,
                chatBotLocalService: chatBotLocalService
            )
        }

        // View Models
        container.register(ContentViewModel.self) { _ in ContentViewModel() }
        container.register(FriendsListViewModel.self) { _ in FriendsListViewModel() }
        container.register(FriendAddViewModel.self) { _ in FriendAddViewModel() }
        container.register(MyWallViewModel.self) { _ in MyWallViewModel() }
        container.register(MessageBubbleViewModel.self) { _ in MessageBubbleViewModel() }
        container.register(QRCodeScannerViewModel.self) { _ in QRCodeScannerViewModel() }
        container.register(PreferencesViewModel.self) { _ in PreferencesViewModel() }
        container.register(SignInViewModel.self) { _ in SignInViewModel() }
        container.register(SignUpViewModel.self) { resolver in
            SignUpViewModel(signUpUserModel: resolver.resolve(SignUpUserModel.self) ?? SignUpUserModel() )
        }
        container.register(SplashViewModel.self) { _ in SplashViewModel() }
        container.register(UserViewModel.self) { _ in UserViewModel() }
        container.register(UserProfileImageViewModel.self) { _ in UserProfileImageViewModel() }
        container.register(ImageViewModel.self) { _ in ImageViewModel() }
        container.register(ChatBotViewModel.self) { resolver in
            return ChatBotViewModel()
        }
        
        container.register(TimeTimerViewModel.self) { _ in TimeTimerViewModel() }

        container.register(TaskViewModel.self) { _ in TaskViewModel() }
        container.register(CharacterViewModel.self) { _ in CharacterViewModel() }
        container.register(CalendarViewModel.self) { _ in CalendarViewModel() }
        container.register(CameraPermissionViewModel.self) { _ in CameraPermissionViewModel() }
   }

    func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
        return container.resolve(serviceType, name: name)!
    }

}
