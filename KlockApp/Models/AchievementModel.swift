//
//  AchievementModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/27.
//

import Foundation

struct AchievementModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var image: String
}
