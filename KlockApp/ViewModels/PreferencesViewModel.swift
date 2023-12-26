//
//  PreferencesViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/04.
//

import Foundation
import Combine
import SwiftUI
import Foast
import FamilyControls

enum ActionType {
    case copyToken
    case theme
    case plannerSettings
    case alarm
    case qrCode
    case category
    case allowedAppSettings
    case privacy
    case feedback
    case accountAndSecurity
    case inquiries
    case logout
    case deleteAccount
    case loading
    case none
}

class PreferencesViewModel: ObservableObject {
    @Published var isAppsSettingPresented = false
    @Published var selection = FamilyActivitySelection()
    @Published var profileImage: String  = "ic_img_logo"
    @Published var profileName: String = "User Name"
    lazy var preferencesSections: [SectionModel] = [
        SectionModel(items: [
            ItemModel(title: "허용앱 설정", iconName: "ic_four_square", actionType: .allowedAppSettings, action: {
                if #available(iOS 16.0, *) {
                    self.isAppsSettingPresented = true
                } else {
                    Foast.show(message: "iOS 16에서 사용할 수 있습니다.")
                }
            }),
            ItemModel(title: "계정 및 보안", iconName: "ic_shield_o", actionType: .accountAndSecurity, destinationView: AnyView(AccountSecurityView())),
        ]),
        SectionModel(items: [
            ItemModel(title: "서비스 이용약관", systemIconName: "text.badge.checkmark", actionType: .privacy, action: {
                if let url = URL(string: "https://klock.app/policies/terms-of-use.html") {
                    UIApplication.shared.open(url)
                }
            }),
            ItemModel(title: "개인정보 처리방침", systemIconName: "lock.doc.fill", actionType: .privacy, action: {
                if let url = URL(string: "https://klock.app/policies/privacy-policy.html") {
                    UIApplication.shared.open(url)
                }
            }),
        ]),
        SectionModel(items: [
            ItemModel(title: "문의 사항", iconName: "ic_circle_q_mark", actionType: .inquiries, action: {
                if let url = URL(string: "mailto:hello@8hlab.com") {
                    UIApplication.shared.open(url)
                }
            })
        ]),
    ]
    @Published var accountSecuritySections: [SectionModel] = [
        SectionModel(items: [
            ItemModel(title: "로그아웃", systemIconName: "arrowshape.turn.up.left.fill", actionType: .logout),
            ItemModel(title: "탈퇴하기", systemIconName: "xmark.circle.fill", actionType: .deleteAccount)
        ])
    ]
    let logoutButtonTapped = PassthroughSubject<Void, Never>()
    let deleteAccountButtonTapped = PassthroughSubject<Void, Never>()

    private let userRemoteService: UserRemoteServiceProtocol = Container.shared.resolve(UserRemoteServiceProtocol.self)

    private var cancellables: Set<AnyCancellable> = []

    func editProfile() {
        // Handle profile editing
        print("Edit profile button pressed")
    }
    
    // 로그아웃 메소드
    func logout() {
        UserDefaults.standard.removeObject(forKey: "access.token")
    }

    // 계정 삭제 메소드
    func deleteAccount() {
        guard let userModel = UserModel.load() else {
            print("사용자 정보가 없습니다.")
            return
        }
        userRemoteService.delete(id: userModel.id)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("delete account success")
                }
            } receiveValue: { [weak self] response in
                print(response)
                self?.logout()
            }
            .store(in: &cancellables)
    }
    
    init() {
        logoutButtonTapped
            .sink { [weak self] _ in
                self?.logout()
            }
            .store(in: &cancellables)

        deleteAccountButtonTapped
            .sink { [weak self] _ in
                self?.deleteAccount()
            }
            .store(in: &cancellables)
        
        let userModel = UserModel.load()
        profileName = userModel?.nickname ?? "-"
        if let profileImage = userModel?.profileImage {
            self.profileImage = profileImage
        }
        
        #if DEBUG
        preferencesSections.insert(SectionModel(items: [
            ItemModel(title: "토큰 복사", systemIconName: "doc.on.doc.fill", actionType: .copyToken, action: {
                let jwtToken = UserDefaults.standard.string(forKey: "access.token") ?? ""
                UIPasteboard.general.string = jwtToken
                Foast.show(message: "복사 했습니다.")
            })
        ]), at: 0)
        #endif
    }
}
