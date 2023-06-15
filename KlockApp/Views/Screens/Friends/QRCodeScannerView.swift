//
//  QRCodeScannerView.swift
//  NiceIpin
//
//  Created by 성찬우 on 2023/06/13.
//

import SwiftUI
import AVFoundation
import Combine

struct QRCodeScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: QRCodeScannerViewModel
    
    func makeUIViewController(context: Context) -> QRCodeScannerViewController {
        let viewController = QRCodeScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: QRCodeScannerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(scanner: self)
    }

    class Coordinator: NSObject, QRCodeScannerViewControllerDelegate {
        let scanner: QRCodeScannerView

        init(scanner: QRCodeScannerView) {
            self.scanner = scanner
        }

        func qrCodeScanner(_ scanner: QRCodeScannerViewController, didDetectQRCode code: String) {
            self.scanner.viewModel.processScannedCode(code)
//            self.scanner.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerOverlay()
    }
}

struct QRCodeScannerOverlay: View {
    @StateObject private var viewModel = Container.shared.resolve(QRCodeScannerViewModel.self)

    var body: some View {
        ZStack {
            QRCodeScannerView(viewModel: viewModel)
            NavigationLink(destination: FriendAddDoneView(),
                           isActive: $viewModel.isNavigatingToNextView) {
                EmptyView()
            }
        }
    }
}
