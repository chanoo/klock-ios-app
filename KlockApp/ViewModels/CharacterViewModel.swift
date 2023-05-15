//
//  CharacterViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/27.
//

import Foundation
import Combine
import SwiftUI

class CharacterViewModel: ObservableObject {
    @Published var level: Int = 1
    @Published var experience: Int = 0
    @Published var achievements: [AchievementModel] = []
    
    func addExperience(points: Int) {
        experience += points
        checkLevelUp()
    }
    
    func checkLevelUp() {
        if experience >= level * 100 {
            level += 1
            experience = 0
            unlockAchievements()
        }
    }
    
    func unlockAchievements() {
        // 캐릭터 레벨에 따른 업적을 추가하는 로직을 구현합니다.
    }
    
    func copyToken() {
        let jwtToken = UserDefaults.standard.string(forKey: "access.token") ?? ""
        UIPasteboard.general.string = jwtToken
    }
}
