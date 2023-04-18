//
//  AmbientLightViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/18.
//

import Foundation
import Combine
import AudioToolbox

class AmbientLightViewModel: ObservableObject {
    private let ambientLightService: AmbientLightService
    private var cancellable: AnyCancellable?

    @Published var isDark: Bool = false

    init(ambientLightService: AmbientLightService) {
        self.ambientLightService = ambientLightService
        setupSensor()
    }

    private func setupSensor() {
        cancellable = ambientLightService.setupSensor()
            .assign(to: \.isDark, on: self)
    }
    
    func playVibration() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
