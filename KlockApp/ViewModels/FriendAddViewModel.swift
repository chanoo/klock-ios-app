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
    
    func generateQRCode(from string: String) {
        let data = Data(string.utf8)
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
