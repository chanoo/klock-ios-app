//
//  AmbientLightServiceProtocol.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/19.
//

import Foundation
import Combine

protocol ProximityAndOrientationServiceProtocol {
    func setupSensor() -> AnyPublisher<Bool, Never>
}
