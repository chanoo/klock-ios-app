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
import Alamofire
import Foast

class UserProfileImageViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showImagePicker: Bool = false
    @Published var userModel = UserModel.load()
    @Published var isNickNameButtonEnabled = false
    @Published var nicknameTextFieldShouldBecomeFirstResponder: Bool = false
    @Published var nickname = ""
    @Published var showingImagePicker = false
    @Published var error: String?
    @Published var isLoading: Bool = false

    // 카메라 권한 관련
    @Published var cameraPermissionGranted: Bool = false
    @Published var isShowCemeraPermissionView: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    let confirmTapped = PassthroughSubject<Void, Never>()
    
    private let userRemoteService = Container.shared.resolve(UserRemoteServiceProtocol.self)
    
    init() {
        nickname = userModel?.nickname ?? ""
        setupConfirmTapped()
    }
    
    private func setupConfirmTapped() {
        $nickname
            .removeDuplicates()
            .map { [weak self] nickname -> String in
                self?.error = nil
                if self?.selectedImage != nil {
                    self?.isNickNameButtonEnabled = true
                } else {
                    self?.isNickNameButtonEnabled = false
                }
                return nickname
            }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // 0.5초 동안 대기
            .map { [weak self] nickname -> String in
                if nickname.count < 2 {
                    self?.error = "2글자 이상 입력 해주세요"
                    self?.isNickNameButtonEnabled = false
                    return "" // 빈 문자열을 반환하여 다음 단계를 중단
                } else {
                    self?.error = nil // 에러 메시지 초기화
                    return nickname // 조건을 만족하는 경우 닉네임 반환
                }
            }
            .filter { $0 != self.userModel?.nickname && !$0.isEmpty } // 빈 문자열인 경우 필터링
            .flatMap { nickname in
                return self.userRemoteService.existed(nickname: nickname)
                    .replaceError(with: ExistedNicknameResDTO(exists: false))
                    .receive(on: DispatchQueue.main)
            }
            .sink { [weak self] response in
                if response.exists {
                    self?.error = "다른 친구가 이미 사용 중이에요"
                    self?.isNickNameButtonEnabled = false
                } else {
                    self?.nicknameTextFieldShouldBecomeFirstResponder = true
                    self?.isNickNameButtonEnabled = true
                }
            }
            .store(in: &cancellables)
        
        $selectedImage
            .sink { image in
                if image != nil {
                    self.nicknameTextFieldShouldBecomeFirstResponder = true
                    self.isNickNameButtonEnabled = true
                }
            }
            .store(in: &cancellables)

        confirmTapped
            .sink { [weak self] _ in
                let userModel = UserModel.load()
                guard let userId = userModel?.id, let nickname = userModel?.nickname else {
                    return
                }
                self?.isLoading = true
                self?.nicknameTextFieldShouldBecomeFirstResponder = false
                self?.updateUserInfo(userId: userId, nickname: self?.nickname ?? nickname)
            }
            .store(in: &cancellables)
    }
    
    func updateProfileImage(userId: Int64) {
        let _selectedImage = selectedImage?.resize(to: CGSize(width: 600, height: 600))
        guard let pngData = _selectedImage?.pngData() else {
            return
        }
        uploadProfileImage(userId: userId, imageData: pngData)
    }
    
    func uploadProfileImage(userId: Int64, imageData: Data) {
        let request = ProfileImageReqDTO(file: imageData)
        userRemoteService.profileImage(id: userId, request: request)
            .sink(receiveCompletion: handleFetchDataCompletion,
                  receiveValue: handleReceivedUploadProfileImageDataResponse)
            .store(in: &cancellables)
    }
    
    func handleReceivedUploadProfileImageDataResponse(_ dto: ProfileImageResDTO) {
        var userModel = UserModel.load()
        userModel?.profileImage = dto.profileImage
        userModel?.save()
        isLoading = false
    }
    
    func updateUserInfo(userId: Int64, nickname: String) {
        let request = UserUpdateReqDTO(
            nickname: nickname,
            tagId: userModel?.tagId ?? 0,
            startOfTheWeek: userModel?.startOfTheWeek ?? "MONDAY",
            startOfTheDay: userModel?.startOfTheDay ?? 5
        )
        
        userRemoteService.update(id: userId, request: request)
            .sink(receiveCompletion: handleFetchDataCompletion,
                  receiveValue: handleReceivedUpdateUserInfoResponse)
            .store(in: &cancellables)
    }
    
    func handleReceivedUpdateUserInfoResponse(_ dto: UserUpdateResDTO) {
        var userModel = UserModel.load()
        guard let userId = userModel?.id else {
            return
        }
        userModel?.nickname = nickname
        userModel?.save()
        
        if selectedImage != nil {
            self.updateProfileImage(userId: userId)
        } else {
            isLoading = false
        }
    }

    // 공통 핸들러
    func handleFetchDataCompletion(_ completion: Subscribers.Completion<AFError>) {
        switch completion {
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
            Foast.show(message: error.localizedDescription)
        case .finished:
            break
        }
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
        cancellables.forEach { $0.cancel() }
    }
}
