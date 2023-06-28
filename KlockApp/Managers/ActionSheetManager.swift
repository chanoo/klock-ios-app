//
//  ActionSheetManager.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/28.
//

import Foundation

class ActionSheetManager: ObservableObject {
    @Published var isPresented = false
    @Published var actionSheet: CustomActionSheetView? = nil
}
