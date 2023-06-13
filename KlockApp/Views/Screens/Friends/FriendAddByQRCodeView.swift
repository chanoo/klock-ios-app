//
//  FriendAddByQRCodeView.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/06/12.
//

import SwiftUI
import AVFoundation

struct FriendAddByQRCodeView: UIViewRepresentable {
    @EnvironmentObject var viewModel: FriendAddViewModel

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        let captureSession = AVCaptureSession()

        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
            } catch {
                print(error.localizedDescription)
            }

            let metadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]

            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)

            captureSession.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: FriendAddByQRCodeView

        init(_ parent: FriendAddByQRCodeView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first,
               let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
               let stringValue = readableObject.stringValue {
                parent.viewModel.updateScanResult(ScanResult(type: readableObject.type.rawValue, data: stringValue))
            }
        }
    }

}

struct FriendAddByQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = FriendAddViewModel()
        FriendAddByQRCodeView()
            .environmentObject(viewModel)
    }
}
