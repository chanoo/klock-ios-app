//
//  UserProfileImageViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 12/14/23.
//

import Foundation
import Combine
import UIKit
import AVFoundation

class UserProfileImageViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var userModel = UserModel.load()
    @Published var isNickNameButtonEnabled = false
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false
    @Published var nickname = ""
    @Published var showingImagePicker = false
    
    // 카메라 권한 관련
    @Published var cameraPermissionGranted: Bool = false
    @Published var isShowCemeraPermissionView: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []

    let confirmTapped = PassthroughSubject<Void, Never>()
    
    private let userRemoteService = Container.shared.resolve(UserRemoteServiceProtocol.self)
    
    init() {
        nickname = userModel?.nickname ?? ""
    }
    
    func isCameraPermissionGranted() -> Bool {
        return cameraPermissionGranted
    }
    
    func showImagePickerView() {
        self.showingImagePicker = true
    }

    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            cameraPermissionGranted = true
        default:
            cameraPermissionGranted = false
        }
    }
    
    func showCameraPermissionView() {
        isShowCemeraPermissionView = true
    }

    func initCameraPermissionView() {
        isShowCemeraPermissionView = false
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel() }
    }
}
