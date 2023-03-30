//
//  KlockAppApp.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/03/30.
//

import SwiftUI

@main
struct KlockAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
