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
    
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        $scannedCode.sink { code in
            debugPrint(code ?? "-")
        }
        .store(in: &cancellableSet)
    }

    func processScannedCode(_ code: String) {
        scannedCode = code
        self.isNavigatingToNextView = true
    }
    
    func restartScanning() {
        self.isScanning = true
    }
}
