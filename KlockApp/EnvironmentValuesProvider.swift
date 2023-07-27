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
    let kakaoAPIKey: String

    private init() {
        guard let openaiAPIKey = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("OPENAI_API_KEY not defined in Info.plist.")
        }
        self.openaiAPIKey = openaiAPIKey
        guard let kakaoAPIKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else {
            fatalError("KAKAO_API_KEY not defined in Info.plist.")
        }
        self.kakaoAPIKey = kakaoAPIKey
    }
}

extension EnvironmentValues {
    var openaiAPIKey: String {
        get { EnvironmentValuesProvider.shared.openaiAPIKey }
    }
}
