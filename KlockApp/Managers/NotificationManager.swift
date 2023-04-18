//
//  NotificationManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/18.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, ObservableObject {
    static func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "어두운 환경 감지"
        content.body = "화면이 뒤집어진 상태에서 어두운 환경을 감지했습니다."
        content.sound = UNNotificationSound.default // 진동 추가

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "ambientLightNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: \(error)")
            }
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
