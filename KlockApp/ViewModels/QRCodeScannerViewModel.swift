//
//  QRCodeScannerViewModel.swift
//  NiceIpin
//
//  Created by 성찬우 on 2023/06/13.
//

import Combine

class QRCodeScannerViewModel: ObservableObject {
    @Published var scannedCode: String?
    @Published var isNavigatingToNextView = false
    @Published var isScanning = false
    
    private var cancellables: Set<AnyCancellable> = []

    private let friendRelationService = Container.shared.resolve(FriendRelationServiceProtocol.self)

    init() {
        $scannedCode.sink { code in
            debugPrint(code ?? "-")
            guard let code = code else { return }
            if let request = FriendRelationFollowQRCodeReqDTO.decode(from: code) {
                self.friendRelationService.followQRCode(request: request)
                    .sink(receiveCompletion: { result in
                        switch result {
                        case .failure(let error):
                            print("Error deleting user trace: \(error)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { _ in
                        // 로컬에서 사용자 추적 데이터 삭제
                    })
                    .store(in: &self.cancellables)
            }
        }
        .store(in: &cancellables)
    }

    func processScannedCode(_ code: String) {
        scannedCode = code
        self.isNavigatingToNextView = true
    }
    
    func restartScanning() {
        self.isScanning = true
    }
}
