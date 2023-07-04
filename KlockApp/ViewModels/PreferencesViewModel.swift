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

class PreferencesViewModel: ObservableObject {
    @Published var profileImage: String  = "ic_img_logo"
    @Published var profileName: String = "User Name"
    @Published var sections: [SectionModel] = [
        SectionModel(items: [
            ItemModel(title: "토큰 복사", iconName: "doc.on.doc.fill", action: {
                let jwtToken = UserDefaults.standard.string(forKey: "access.token") ?? ""
                UIPasteboard.general.string = jwtToken
                Foast.show(message: "복사 했습니다.")
            }),
        ]),
        SectionModel(items: [
            ItemModel(title: "테마", iconName: "sun.max.fill"),
            ItemModel(title: "플래너 설정", iconName: "calendar"),
            ItemModel(title: "알람", iconName: "bell"),
            ItemModel(title: "QR코드", iconName: "qrcode"),
            ItemModel(title: "카테고리", iconName: "folder"),
            ItemModel(title: "허용앱 설정", iconName: "app")
        ]),
        SectionModel(items: [
            ItemModel(title: "개인정보 보호", iconName: "person.fill"),
            ItemModel(title: "도움말 피드백", iconName: "bubble.left.and.bubble.right.fill"),
            ItemModel(title: "계정 및 보안", iconName: "lock.fill"),
            ItemModel(title: "문의 사항", iconName: "envelope.fill")
        ]),
        SectionModel(items: [
            ItemModel(title: "로그아웃", iconName: "arrowshape.turn.up.left.fill"),
            ItemModel(title: "탈퇴하기", iconName: "xmark.circle.fill")
        ])
    ]
    
    func editProfile() {
        // Handle profile editing
        print("Edit profile button pressed")
    }
}
