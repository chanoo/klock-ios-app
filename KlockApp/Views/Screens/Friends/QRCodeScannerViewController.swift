//
//  QRCodeScannerViewController.swift
//  NiceIpin
//
//  Created by 성찬우 on 2023/06/13.
//

import AVFoundation
import UIKit

protocol QRCodeScannerViewControllerDelegate: AnyObject {
    func qrCodeScanner(_ scanner: QRCodeScannerViewController, didDetectQRCode code: String)
}

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: QRCodeScannerViewControllerDelegate?
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var guideView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupPreviewLayer()
//        setupGuideView()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
    }

    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    func setupGuideView() {
        guideView = UIImageView(image: UIImage(named: "img_qr_guide"))
        guideView.translatesAutoresizingMaskIntoConstraints = false
        guideView.contentMode = .scaleAspectFill
        view.addSubview(guideView)
        
        NSLayoutConstraint.activate([
            guideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guideView.topAnchor.constraint(equalTo: view.topAnchor),
            guideView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let code = readableObject.stringValue else { return }

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.qrCodeScanner(self, didDetectQRCode: code)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
}
