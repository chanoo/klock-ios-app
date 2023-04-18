//
//  AmbientLightService.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/04/18.
//

import Foundation
import CoreMotion
import Combine
import UIKit

class ProximityAndOrientationService: ProximityAndOrientationServiceProtocol {
    private let motionManager: CMMotionManager
    private var cancellable: AnyCancellable?
    private var isUpsideDown = false

    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
        setupProximitySensor()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }

    private func checkForUpsideDown(_ motion: CMDeviceMotion) -> Bool {
        let gravity = motion.gravity
        let x = gravity.x
        let y = gravity.y
        let z = gravity.z
        
        return z > 0.8 && (x >= -0.5 && x <= 0.5) && (y >= -0.5 && y <= 0.5)
    }

    private func setupProximitySensor() {
        NotificationCenter.default.addObserver(self, selector: #selector(proximityStateChanged), name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }

    @objc private func proximityStateChanged() {
        let isProximityActive = UIDevice.current.proximityState
        if isUpsideDown {
            UIApplication.shared.isIdleTimerDisabled = isProximityActive
            if isProximityActive {
                NotificationManager.sendLocalNotification()
            }
        } else {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    func setupSensor() -> AnyPublisher<Bool, Never> {
        let subject = PassthroughSubject<Bool, Never>()
        
        guard motionManager.isDeviceMotionAvailable else {
            return Just(false).eraseToAnyPublisher()
        }
        
        motionManager.deviceMotionUpdateInterval = 0.5

        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (_, _) in
            if let motion = self?.motionManager.deviceMotion {
                self?.isUpsideDown = self?.checkForUpsideDown(motion) ?? false
                let isConditionMet = self?.isUpsideDown ?? false
                let isProximityActive = UIDevice.current.proximityState
                let device = UIDevice.current
                if isConditionMet {
                    device.isProximityMonitoringEnabled = true
                } else {
                    device.isProximityMonitoringEnabled = false
                }
                
                subject.send(isConditionMet && isProximityActive)
            }
        }

        return subject.eraseToAnyPublisher()
    }
}
