//
//  QRCodeScannerViewModel.swift
//  NiceIpin
//
//  Created by 성찬우 on 2023/06/13.
//

import Combine

class QRCodeScannerViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()

    @Published var scannedCode: String?
    
    func processScannedCode(_ code: String) {
        scannedCode = code
    }
}
