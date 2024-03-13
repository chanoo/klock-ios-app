//
//  FriendAddViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import Combine
import CoreLocation
import CryptoKit

enum ActiveView {
    case scanQRCode
    case myQRCode
}

class FriendAddViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var beaconIdentityConstraint: CLBeaconIdentityConstraint
    @Published var nearbyBeacons: [CLBeacon] = []
    @Published var scanResult: ScanResult?
    @Published var activeView: ActiveView = .scanQRCode
    @Published var activeSheet: SheetType?
    @Published var nickname: String
    @Published var error: String?
    @Published var becomeFirstResponder: Bool = false
    @Published var isNextButtonDisabled: Bool? = true
    @Published var isNavigatingToNextView = false
    @Published var friendUser: SearchByNicknameResDTO?
    @Published var followingFriendUser: FriendRelationFollowResDTO?

//    let beaconManager = BeaconManager()

    private let userModel = UserModel.load()
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    @Published var qrCodeImage: UIImage?
    @Published var centerImage: UIImage?
    
    let addFriendButtonTapped = PassthroughSubject<Void, Never>()

    var isStartOfWeekNextButtonEnabledCancellable: AnyCancellable?

    private let userRemoteService = Container.shared.resolve(UserRemoteServiceProtocol.self)
    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)

    private var cancellables = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?

    override init() {
        print("init FriendAddViewModel")
        locationManager = CLLocationManager()
        beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(),
                                                              major: 1, minor: 456)
        nickname = ""
        super.init()
        locationManager.delegate = self
        setupNicknameSearch()
        setupAddFriendButtonTapped()
    }
    
    private func setupNicknameSearch() {
        $nickname
            .removeDuplicates() // 연속된 중복 값 필터링
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main) // 사용자 입력 후 0.5초 대기
            // $nickname이 0 이상일때만 보내기
            .filter { !$0.isEmpty }
            .sink { [weak self] nickname in
                guard let self = self else { return }
                self.error = nil
                self.isNextButtonDisabled = true
                self.searchNickname(nickname)
            }
            .store(in: &cancellables)
    }
    
    private func searchNickname(_ nickname: String) {
        // 이전 요청이 있다면 취소합니다.
        searchCancellable?.cancel()

        // 닉네임 검색 로직 구현, 예시로 userRemoteService 사용
        searchCancellable = userRemoteService.searchBy(nickname: nickname)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print(error) // 에러 처리
                    if (error.code == 204) {
                        self.error = "친구 닉네임을 확인해주세요"
                    } else {
                        self.error = error.message
                    }
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.friendUser = response
                self?.isNextButtonDisabled = response?.nickname.isEmpty
            })
    }
    
    private func setupAddFriendButtonTapped() {
        addFriendButtonTapped
            .sink { [weak self] _ in
                guard let self = self, let followId = self.friendUser?.id else {
                    self?.error = "팔로우할 사용자가 선택되지 않았습니다"
                    return
                }
                
                self.friendRelationService.follow(followId: followId)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = "사용자 팔로우 실패: \(error.localizedDescription)"
                                self.isNavigatingToNextView = false
                            }
                        case .finished:
                            break
                        }
                    }, receiveValue: { user in
                        self.followingFriendUser = user
                        DispatchQueue.main.async {
                            self.isNextButtonDisabled = true
                            self.isNavigatingToNextView = true
                        }
                    })
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }

    func updateScanResult(_ result: ScanResult) {
        scanResult = result
    }

    func startScanning() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startRangingBeacons(satisfying: beaconIdentityConstraint)
    }

    func stopScanning() {
        locationManager.stopRangingBeacons(satisfying: beaconIdentityConstraint)
    }

    func locationManager(_ manager: CLLocationManager,
                         didRange beacons: [CLBeacon],
                         satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        nearbyBeacons = beacons
    }
    
    func generateInviteQRCode() -> FollowQRCode? {
        // 사용자 모델을 불러오고 필요한 데이터가 있는지 확인합니다.
        guard let userModel = UserModel.load(),
              let base64PublicKey = UserDefaults.standard.string(forKey: "public.key") else {
            return nil // 필요한 데이터가 없으면 nil을 반환합니다.
        }

        // 옵셔널이 아닌 userId를 사용합니다.
        let userId = userModel.id

        // 128비트 AES 키를 생성합니다.
        let aesKey = SymmetricKey(size: .bits128)
        let aesKeyData = aesKey.toData()

        // RSA 공개 키를 사용하여 AES 키를 암호화합니다.
        guard let publicKey = RSACrypto.publicKey(from: base64PublicKey),
              let encryptedAESKey = RSACrypto.encryptData(aesKeyData, using: publicKey) else {
            return nil // RSA 암호화에 실패하면 nil을 반환합니다.
        }
        let encryptedAESKeyBase64 = encryptedAESKey.base64EncodedString()

        // 팔로우 코드를 준비하고 암호화합니다.
        let followCode = createFollowCode(for: userId)
        guard let followCodeJson = followCode.toJson(),
              let encryptedFollowCodeData = AESCrypto.encryptString(followCodeJson, using: aesKey) else {
            return nil // AES 암호화에 실패하면 nil을 반환합니다.
        }
        let encryptedFollowCodeBase64 = encryptedFollowCodeData.base64EncodedString()

        // FollowQRCode 객체를 반환합니다.
        return FollowQRCode(followData: encryptedFollowCodeBase64, encryptedKey: encryptedAESKeyBase64)
    }

    func generateQRCode() {
        guard let qrCode = generateInviteQRCode()?.toJson() else {
            return
        }
        let data = Data(qrCode.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            // Increase size of the QR code image
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformedImage = outputImage.transformed(by: transform)
            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
                qrCodeImage = UIImage(cgImage: cgimg)
            }
        }
    }

    // Call this function after setting centerImage and qrCodeImage
    func generateQRCodeWithCenterImage() -> UIImage? {
        guard let qrCodeImage = qrCodeImage, let centerImage = centerImage else {
            return nil
        }

        let size = qrCodeImage.size
        UIGraphicsBeginImageContext(size)

        qrCodeImage.draw(in: CGRect(origin: .zero, size: size))

        let centerImageSize = centerImage.size
        let width = centerImageSize.width * 4
        let height = centerImageSize.height * 4
        let rect = CGRect(
            x: (size.width - width) / 2,
            y: (size.height - height) / 2,
            width: width,
            height: height
        )
        centerImage.draw(in: rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage
    }
    
    func closeSheet() {
        activeSheet = nil
    }
}
