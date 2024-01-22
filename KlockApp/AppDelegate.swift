//
//  AppDelegate.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/31.
//

import UIKit
import FacebookCore
import UserNotifications
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate, UIWindowSceneDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let appUsageController = AppUsageController.shared
        appUsageController.stopMonitoring()
    }
}
