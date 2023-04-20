//
//  Toast.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/20.
//

import SwiftUI
import UIKit

class Toast {
    static let sharedInstance = Toast()
    
    private var toastView: UIView?
    private var timer: Timer?

    private init() {}

    private func show(message: String, duration: TimeInterval) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let mainWindow = windowScene.windows.first {
            
            if toastView != nil {
                hideToast()
            }

            let toastView = ToastView(message: message)
            let hostingController = UIHostingController(rootView: toastView)
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            mainWindow.addSubview(hostingController.view)

            let bottomOffset: CGFloat = 140
            NSLayoutConstraint.activate([
                hostingController.view.centerXAnchor.constraint(equalTo: mainWindow.centerXAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: -bottomOffset)
            ])

            self.toastView = hostingController.view

            // Cancel the previous timer if it exists
            timer?.invalidate()
            
            // Create a new timer
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
                self.hideToast()
            }
        }
    }

    private func hideToast() {
        toastView?.removeFromSuperview()
        toastView = nil
    }
}

extension Toast {
    @discardableResult
    static func show(message: String, duration: TimeInterval = 2) -> Toast {
        sharedInstance.show(message: message, duration: duration)
        return sharedInstance
    }
}
