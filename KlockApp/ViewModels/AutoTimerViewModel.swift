//
//  AutoTimerViewModel.swift
//  KlockApp
//
//  Created by 성찬우 on 2023/07/21.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI

class AutoTimerViewModel: ObservableObject {
    class CaptureDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        weak var parent: AutoTimerViewModel?

        init(parent: AutoTimerViewModel) {
            self.parent = parent
            super.init()
        }

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            connection.videoOrientation = .portrait
            parent?.processSampleBuffer(sampleBuffer)
        }
    }
    @Published var originalImage: UIImage?
    @Published var inputImage: UIImage?
    @Published var resultImage: UIImage?
    @Published var legendText: String = ""
    @Published var elapsedTime: TimeInterval = 0
    @Published var isStudying: Bool = false
    @Published var currentTime: Date
    @Published var startTime: Date
    @Published var isRunning: Bool
    @Published var noPersonDetectedFor10Seconds: Bool = false
    @Published var elapsedSecondsWithoutPerson: Int = 0
    @Published var inferenceStatus: String = "" {
        didSet {
            updateInferenceStatus(newStatus: inferenceStatus)  // 여기서 inferenceStatus가 변경될 때마다 updateInferenceStatus를 호출합니다.
        }
    }
    @Published var cameraPermissionGranted: Bool = false
    @Published var isShowCemeraPermissionView: Bool = false

    private var noPersonCounter = 0
    private var captureSession: AVCaptureSession?
    private var imageSegmentationHelper: ImageSegmentationHelper?
    private var targetSize = CGSize(width: 257, height: 257)
    private var frameCounter = 0
    private var captureDelegate: CaptureDelegate!
    private var cancellableSet: Set<AnyCancellable> = []

    var model: AutoTimerModel
    var noPersonTimer: Timer?
    var backgroundEnterTime: Date?

    init(model: AutoTimerModel,
         currentTime: Date = Date(),
         startTime: Date = Date(),
         elapsedTime: TimeInterval = 0,
         isRunning: Bool = false
    ) {
        debugPrint("AutoTimerViewModel init", model.name)
        self.model = model
        self.currentTime = currentTime
        self.startTime = startTime
        self.elapsedTime = elapsedTime
        self.isRunning = isRunning
        
        captureDelegate = CaptureDelegate(parent: self)
        setupSegmentationHelper()
        setupBindings()
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
    
    private func setupCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            else {
                print("ERROR: Unable to access camera.")
                return
            }

            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                let output = AVCaptureVideoDataOutput()
                output.setSampleBufferDelegate(self.captureDelegate, queue: DispatchQueue(label: "VideoFrameProcessingQueue"))
                
                if let connection = output.connection(with: .video), connection.isVideoOrientationSupported {
                    connection.videoOrientation = .portrait
                }

                let session = AVCaptureSession()
                session.addInput(input)
                session.addOutput(output)
            
                self.captureSession = session
                self.captureSession?.startRunning()
                
            } catch let error {
                print("Error setting up AVCaptureDeviceInput: \(error)")
            }
        }
    }

    private func setupSegmentationHelper() {
        ImageSegmentationHelper.newInstance { result in
            switch result {
            case let .success(segmentationHelper):
                self.imageSegmentationHelper = segmentationHelper
            case .failure(_):
                print("Failed to initialize.")
            }
        }
    }

    func processSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        frameCounter += 1
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext(options: nil)

        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage)
            DispatchQueue.main.async {
                self.originalImage = image
            }
            let scaledImage = image.resize(to: targetSize)
            DispatchQueue.main.async {
                self.inputImage = scaledImage
                
                if self.frameCounter % 10 != 0 {
                    return
                }
                
                if self.frameCounter >= 10 {
                    self.frameCounter = 0
                }
                
                self.runSegmentation(scaledImage)
            }
        }
    }

    func runSegmentation(_ image: UIImage) {
        guard let imageSegmentator = imageSegmentationHelper else {
            DispatchQueue.main.async {
                self.inferenceStatus = "ERROR: Image Segmentator is not ready."
            }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            imageSegmentator.runSegmentation(image) { result in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(segmentationResult):
                        // 결과 처리 및 표시 코드
                        self.resultImage = segmentationResult.resultImage.resize(targetSize: image.size)
                        self.inferenceStatus = self.createLegendText(from: segmentationResult)
                    case let .failure(error):
                        self.inferenceStatus = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func createLegendText(from segmentationResult: ImageSegmentationResult) -> String {
        var legendText: String = ""
        segmentationResult.colorLegend.forEach { (className, color) in
            legendText = className
        }
        return legendText
    }
    
    func startStudy() {
        isRunning = true
        isStudying = true
        startTime = Date()
        currentTime = Date()
        originalImage = nil
        inputImage = nil
        resultImage = nil
        noPersonCounter = 0
        noPersonDetectedFor10Seconds = false
        setupCaptureSession()
    }

    func stopStudy() {
        isRunning = false
        isStudying = false
        captureSession?.stopRunning()
        resetNoPersonTimer()
    }
    
    func updateInferenceStatus(newStatus: String) {
        if newStatus != "person" {
            if noPersonTimer == nil {
                noPersonTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    self.elapsedSecondsWithoutPerson += 1
                    
                    if self.elapsedSecondsWithoutPerson >= 12 {
                        self.noPersonDetectedFor10Seconds = true
                        self.resetNoPersonTimer()
                    }
                }
            }
        } else {
            resetNoPersonTimer()
            self.elapsedSecondsWithoutPerson = 0
        }
    }

    func resetNoPersonTimer() {
        noPersonTimer?.invalidate()
        noPersonTimer = nil
        elapsedSecondsWithoutPerson = 0
    }

    func setupBindings() {
        $isStudying.sink { value in
            print("The new value is \(value)")
        }
        .store(in: &cancellableSet)
    }
    
    func countdownText() -> Int {
        let seconds = elapsedSecondsWithoutPerson
        if 5...10 ~= seconds {
            return (10 - seconds)
        }
        return 0
    }

    func elapsedTimeToString() -> String {
        return TimeUtils.elapsedTimeToString(elapsedTime: elapsedTime)
    }
    
    func appWillEnterForeground() {
        if let backgroundTime = self.backgroundEnterTime {
            let elapsedBackgroundTime = Int(Date().timeIntervalSince(backgroundTime))
            self.elapsedSecondsWithoutPerson += elapsedBackgroundTime

            if self.elapsedSecondsWithoutPerson >= 12 {
                self.noPersonDetectedFor10Seconds = true
                // 여기서 resetNoPersonTimer() 메서드를 호출하려면 해당 메서드 또한 ViewModel에 있어야 합니다.
                self.resetNoPersonTimer()
            }
        }
        self.backgroundEnterTime = nil
        self.currentTime = Date()
    }
    
    func appDidEnterBackground() {
        self.backgroundEnterTime = Date()
    }
    
    
    func showCameraPermissionView() {
        isShowCemeraPermissionView = true
    }

    func initCameraPermissionView() {
        isShowCemeraPermissionView = false
    }
}
