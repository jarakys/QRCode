//
//  ViewController.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import QRCodeDetector
import UIKit

import SwiftUI

import AVFoundation

struct QRCodeScanner: UIViewControllerRepresentable {
    var callback: ((String) -> Void)?
    func makeUIViewController(context: UIViewControllerRepresentableContext<QRCodeScanner>) -> UIViewController {
        // Create a QR code scanner
        let scannerViewController = ViewController()
        scannerViewController.callback = callback
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<QRCodeScanner>) {
        print("update ept")
        // Update the view controller
    }
}

class ViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var previewLayer: QRCodeReaderPreviewLayer!
    private let metadataOutput = AVCaptureVideoDataOutput()
    
    private var isConfigured = false
    
    private var qrCodeString: String?
    private var detector: CIDetector? = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
    
    var callback: ((String) -> Void)?
    
    private var animationLayer: CALayer?
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        print("moved")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard isConfigured else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard (captureSession?.isRunning ?? false) == false else { return }
        guard !isConfigured else { return }
        configureQRCodeReader()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
        print("dissappear")
    }
    
    private func configureQRCodeReader() {
        isConfigured = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            captureSession = nil
            return
        }
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.alwaysDiscardsLateVideoFrames = true
            metadataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            metadataOutput.setSampleBufferDelegate(self, queue: .main) //setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            captureSession = nil
            return
        }
        
        let previewLayer = QRCodeReaderPreviewLayer(session: captureSession,
                                                marginSize: 128,
                                                    drawer: { previewLayer in
            let shapeLayer = CAShapeLayer()
            shapeLayer.contents = UIImage(resource: .scanFrameIcon).cgImage
            shapeLayer.frame = previewLayer.maskContainer
            return shapeLayer
        })
        previewLayer.frame = view.bounds
        previewLayer.backgroundColor = UIColor.clear.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
        
        let animationLayer = CALayer()
        animationLayer.contents = UIImage(named: "scanLineIcon")!.cgImage
        animationLayer.frame = CGRect(x: previewLayer.maskContainer.origin.x, y: previewLayer.maskContainer.origin.y + 1, width: previewLayer.maskContainer.width - 2, height: 20)
        animationLayer.isHidden = true
        previewLayer.addSublayer(animationLayer)
        self.animationLayer = animationLayer
    }
    
    private func animateLineToTop() {
        guard let animationLayer = animationLayer else { return }
        animationLayer.isHidden = false
        
        // Add your animation logic here
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = animationLayer.position.y
        animation.toValue = previewLayer.maskContainer.maxY
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        
        animationLayer.add(animation, forKey: "moveToTopAnimation")
    }
    
    private func isInsideLayer(fullImage: CIImage, feature: CIQRCodeFeature) -> Bool {
        let midXFullImage = fullImage.extent.midX
        let midYFullImage = fullImage.extent.midY
        
        let maskRect: CGFloat = 0.38785046729 * fullImage.extent.height //Square
        
        let rect = CGRect(x: midXFullImage - maskRect / 2,
                          y: midYFullImage - maskRect / 2,
                          width: maskRect,
                          height: maskRect)
    
        print(previewLayer.maskContainer.contains(feature.bounds))
        print("isRectInsideRect \(isRectInsideRect(innerRect: feature.bounds, outerRect: rect)))")
        return isRectInsideRect(innerRect: feature.bounds, outerRect: rect)
    }
    
    func isRectInsideRect(innerRect: CGRect, outerRect: CGRect) -> Bool {
        return innerRect.origin.x >= outerRect.origin.x &&
               innerRect.origin.y >= outerRect.origin.y &&
               (innerRect.origin.x + innerRect.size.width) <= (outerRect.origin.x + outerRect.size.width) &&
               (innerRect.origin.y + innerRect.size.height) <= (outerRect.origin.y + outerRect.size.height)
    }
}

// MARK: - CAAnimationDelegate
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let qrCodeString else {
            animationLayer?.isHidden = true
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.animationLayer?.isHidden = true
                self.callback?(qrCodeString)
            }
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuf = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        guard let image = Optional(CIImage(cvImageBuffer: imageBuf)) else { return }
        guard let features = detector?.features(in: image) as? [CIQRCodeFeature] else { return }
        features.forEach({ feature in
            if isInsideLayer(fullImage: image, feature: feature) {
                qrCodeString = feature.messageString
                captureSession.stopRunning()
                animateLineToTop()
            }
        })
    }
}


class ViewController2: UIViewController {
    let detector = VideoDetector()
    var previewLayer: QRCodeReaderPreviewLayer?
    
    private var isConfigured: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func convertCoordinates(_ coordinates: CGRect, from sourceRect: CGRect, to destinationRect: CGRect) -> CGRect {
            let x = (coordinates.origin.x - sourceRect.origin.x) / sourceRect.size.width * destinationRect.size.width
            let y = (coordinates.origin.y - sourceRect.origin.y) / sourceRect.size.height * destinationRect.size.height
            let width = coordinates.size.width / sourceRect.size.width * destinationRect.size.width
            let height = coordinates.size.height / sourceRect.size.height * destinationRect.size.height

            return CGRect(x: x, y: y, width: width, height: height)
        }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !isConfigured else { return }
        isConfigured = true
        do {
            try self.detector.startDetecting { [weak self] fullImage, features in
                guard let self else { return }
                guard let previewLayer = self.previewLayer else { return }
                guard let feature = features.first else { return }
                
                let itemCoordinatesInPreviewLayer = self.convertCoordinates(feature.bounds, from: fullImage.extent, to: previewLayer.bounds)
                print(itemCoordinatesInPreviewLayer)
            
                print(previewLayer.maskContainer.contains(itemCoordinatesInPreviewLayer))
                if previewLayer.maskContainer.origin.x <= itemCoordinatesInPreviewLayer.origin.x &&
                    previewLayer.maskContainer.origin.x + previewLayer.maskContainer.width >= itemCoordinatesInPreviewLayer.origin.x + itemCoordinatesInPreviewLayer.width &&
                    previewLayer.maskContainer.origin.y <= itemCoordinatesInPreviewLayer.origin.y &&
                    previewLayer.maskContainer.origin.y + previewLayer.maskContainer.height >= itemCoordinatesInPreviewLayer.origin.y + itemCoordinatesInPreviewLayer.height
                {
                    print("Success")
                }
                print("[test] maskContainer \(previewLayer.maskContainer)")
                print("[test] itemCoordinatesInPreviewLayer \(itemCoordinatesInPreviewLayer)")
                self.updateForQRCodes(features)
            }
        }
        catch {
            Swift.print("Could not start video capture (error: \(error))")
            Swift.print("Note that the simulator does not have a video capture device, so you need to run this on a 'real' device")
            fatalError()
        }

        let pl = try! self.detector.makePreviewLayer()

//        self.view.layer.addSublayer(pl)
        let previewLayer = QRCodeReaderPreviewLayer(session: pl.session!,
                                                    marginSize: 128,
                                                    drawer: { previewLayer in
            let shapeLayer = CAShapeLayer()
            shapeLayer.contents = UIImage(resource: .scanFrameIcon).cgImage
            shapeLayer.frame = previewLayer.maskContainer
            return shapeLayer
        })
        previewLayer.frame = self.view.layer.bounds
        previewLayer.backgroundColor = UIColor.clear.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }

    func updateForQRCodes(_ features: [CIQRCodeFeature]) {
        Swift.print("\(features.count) QR code(s) detected [")
        features.forEach { feature in
//            Swift.print("- \(feature.messageString ?? ""), bounds=\(feature.bounds)")
        }
        Swift.print("]")
    }
}


class VideoDetector: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    /// Errors generated by the video detector
    public enum CaptureError: Error {
        case noSession
        case noDefaultVideoDevice
        case cannotCreateVideoInput
        case cannotAddVideoOutput
    }

    /// The format for the callback block when a QR code is detected in the input stream
    public typealias DetectionBlock = (CIImage, [CIQRCodeFeature]) -> Void

    /// Start detecting qr codes in a video stream
    /// - Parameters:
    ///   - captureQueue: The queue to run the capture session. Defaults to `.global`
    ///   - queue: The queue to process results on. Defaults to `.global`
    ///   - inputDevice: the capture input device, or nil to use the system's default video input device
    ///   - detectionBlock: Called when qr code(s) are detected in the input video stream
    public func startDetecting(
        captureQueue: DispatchQueue = .global(),
        queue: DispatchQueue = .global(),
        inputDevice: AVCaptureDeviceInput? = nil,
        _ detectionBlock: @escaping DetectionBlock
    ) throws {
        self.detectionBlock = detectionBlock

        var device = inputDevice
        if device == nil {
            guard let defaultVideo = AVCaptureDevice.default(for: AVMediaType.video) else {
                throw CaptureError.noDefaultVideoDevice
            }
            device = try AVCaptureDeviceInput(device: defaultVideo)
        }

        guard let device = device else { throw CaptureError.cannotCreateVideoInput }

        // Create a capture session
        let session = AVCaptureSession()
        session.addInput(device)

        // Create a video output
        let output = AVCaptureVideoDataOutput()
        guard session.canAddOutput(output) else {
            throw CaptureError.cannotAddVideoOutput
        }

        output.alwaysDiscardsLateVideoFrames = true
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        output.setSampleBufferDelegate(self, queue: queue)
        session.addOutput(output)

        // Create the QRCode detector
        self.detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)

        self.captureSession = session

        captureQueue.async {
            session.startRunning()
        }
    }

    /// Returns a `AVCaptureVideoPreviewLayer` which reflects the content of the current capture session
    public func makePreviewLayer() throws -> AVCaptureVideoPreviewLayer {
        guard let session = self.captureSession else {
            throw CaptureError.noSession
        }
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspect
        return preview
    }

    /// Stop capturing input video
    public func stopDetection() {
        if let captureSession = self.captureSession {
            captureSession.stopRunning()
        }
        captureSession = nil
        self.detectionBlock = nil
        self.detector = nil
    }

    deinit {
        self.stopDetection()
    }

    // Private

    private var captureSession: AVCaptureSession?
    private var detector: CIDetector?
    private var detectionBlock: DetectionBlock?

    private let videoDataOutputQueue = {
        DispatchQueue(
            label: "QRCode.VideoDetector",
            qos: .userInitiated,
            attributes: [],
            autoreleaseFrequency: .inherit)
    }()
}

extension VideoDetector {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if
            let block = self.detectionBlock,
            let imageBuf = CMSampleBufferGetImageBuffer(sampleBuffer),
            let image = Optional(CIImage(cvImageBuffer: imageBuf)),
            let features = detector?.features(in: image) as? [CIQRCodeFeature],
            features.count > 0
        {
            block(image, features)
        }
    }
}
