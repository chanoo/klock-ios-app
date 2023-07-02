//
//  TabBarManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/05/16.
//

import Foundation

class TabBarManager: ObservableObject {
    @Published var isTabBarVisible: Bool = true
    
    func hide() {
        isTabBarVisible = false
    }

    func show() {
        isTabBarVisible = true
    }
}
