//
//  ActionSheetManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import Foundation
import UIKit

class ActionSheetManager: ObservableObject {
    @Published var isPresented = false
    @Published var actionSheet: CustomActionSheetView? = nil
    
    func show() {
        isPresented = true
    }
    
    func hide() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            var topController = rootViewController
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.dismiss(animated: true)
        }
    }
}
