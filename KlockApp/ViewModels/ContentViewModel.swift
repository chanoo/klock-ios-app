//
//  ContentViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

//
//  ContentViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/11.
//

import Combine
import SwiftUI
import Foast
import Combine
import KeychainAccess
import Alamofire

class ContentViewModel: ObservableObject {
    @Published var currentView: AnyView
    private let authService: AuthenticationServiceProtocol = Container.shared.resolve(AuthenticationServiceProtocol.self)
    private let userRemoteService: UserRemoteServiceProtocol = Container.shared.resolve(UserRemoteServiceProtocol.self)
    private let signInViewModel = Container.shared.resolve(SignInViewModel.self)
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        self.currentView = AnyView(LoadingView())
    }

    func updateCurrentView(appFlowManager: AppFlowManager) {
        let userModel = UserModel.load()
        if let userId = userModel?.id, userModel != nil {
            self.userRemoteService.get(id: userId)
                .sink(receiveCompletion: handleFetchDataCompletion,
                      receiveValue: handleReceivedData)
                .store(in: &self.cancellableSet)
        } else {
            self.currentView = AnyView(SignInView()
                .environmentObject(appFlowManager)
                .environmentObject(signInViewModel))
        }
    }
    
    func handleFetchDataCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            logout()
            showSignInView()
        case .finished:
            break
        }
    }
    
    // 로그아웃 메소드
    func logout() {
        let standard = UserDefaults.standard
        standard.removeObject(forKey: "access.token")
        standard.removeObject(forKey: "user")
        standard.synchronize()
    }
    
    func showSignInView() {
        self.currentView = AnyView(SignInView()
            .environmentObject(signInViewModel))
    }
    
    func handleReceivedData(_ dto: GetUserResDTO) {
        let userModel = UserModel.from(dto: dto)
        userModel.save()
        let keychain = Keychain(service: "app.klock.ios")
            .label("app.klock.ios (\(dto.id)")
            .synchronizable(true)
            .accessibility(.afterFirstUnlock)
        keychain["userId"] = String(userModel.id)
        DispatchQueue.main.async {
            self.currentView = AnyView(HomeView()
                .environmentObject(TabBarManager())
            )
        }
    }


}
