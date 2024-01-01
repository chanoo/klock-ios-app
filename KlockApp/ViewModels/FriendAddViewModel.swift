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
    @Published var friends = [
        FriendModel(name: "Alice", isOnline: true),
        FriendModel(name: "Bob", isOnline: false),
        FriendModel(name: "Charlie", isOnline: true)
    ]
    @Published var scanResult: ScanResult?
    @Published var activeView: ActiveView = .scanQRCode
    @Published var activeSheet: SheetType? = Optional.none
    @Published var isPresented = false
    @Published var nickname: String
    @Published var becomeFirstResponder: Bool = false
    @Published var isStartOfWeekNextButtonEnabled = false
    @Published var isNavigatingToNextView = false

//    let beaconManager = BeaconManager()

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    @Published var qrCodeImage: UIImage?
    @Published var centerImage: UIImage?

    var isStartOfWeekNextButtonEnabledCancellable: AnyCancellable?

    override init() {
        locationManager = CLLocationManager()
        beaconIdentityConstraint = CLBeaconIdentityConstraint(uuid: UUID(),
                                                              major: 1, minor: 456)
        nickname = ""
        super.init()
        locationManager.delegate = self
        setupIsNextButtonEnabled()
    }
    
    private func setupIsNextButtonEnabled() {
        isStartOfWeekNextButtonEnabledCancellable = $nickname
            .map { $0.count >= 2 }
            .assign(to: \.isStartOfWeekNextButtonEnabled, on: self)
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

    @available(iOS 13.0, *)
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
        let rect = CGRect(
            x: (size.width - centerImageSize.width) / 2,
            y: (size.height - centerImageSize.height) / 2,
            width: centerImageSize.width,
            height: centerImageSize.height
        )
        centerImage.draw(in: rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resultImage
    }
}
