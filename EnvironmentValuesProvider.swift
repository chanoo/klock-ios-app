//
//  Environment.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/13.
//

import SwiftUI

class EnvironmentValuesProvider {
    static let shared = EnvironmentValuesProvider()

    let openaiAPIKey: String

    private init() {
        guard let apiKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("OPENAI_API_KEY not defined in Info.plist.")
        }
        self.openaiAPIKey = apiKey
    }
}

extension EnvironmentValues {
    var openaiAPIKey: String {
        get { EnvironmentValuesProvider.shared.openaiAPIKey }
    }
}
