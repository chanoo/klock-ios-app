//
//  AppDelegate.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import UIKit
import UserNotifications
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate, UIWindowSceneDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let appUsageController = AppUsageController.shared
        appUsageController.stopMonitoring()
    }
}
