//
//  CameraPermissionViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/09/02.
//

import Combine
import AVFoundation
import UIKit

class CameraPermissionViewModel: ObservableObject {
    @Published var cameraPermissionGranted: Bool = false
    @Published var cameraPermissionStatus: AVAuthorizationStatus = .denied

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        $cameraPermissionStatus
            .sink { status in
                if status == .authorized {
                    // authorized 상태일 때 수행할 동작을 여기에 작성합니다.
                    // 예: 뒤로 가기
                }
            }
            .store(in: &cancellables)
    }

    func checkCameraPermission() {
        cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraPermissionStatus {
        case .authorized:
            cameraPermissionGranted = true
        case .notDetermined:
            cameraPermissionGranted = false
        case .denied:
            cameraPermissionGranted = false
        case .restricted:
            cameraPermissionGranted = false
        default:
            cameraPermissionGranted = false
        }
    }
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraPermissionGranted = granted
            }
        }
    }
}
