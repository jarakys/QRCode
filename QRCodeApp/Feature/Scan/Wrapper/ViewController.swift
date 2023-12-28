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
        // Update the view controller
    }
}

class ViewController: UIViewController {
    private var captureSession: AVCaptureSession!
    private var previewLayer: QRCodeReaderPreviewLayer!
    private let metadataOutput = AVCaptureMetadataOutput()
    private var isConfigured = false
    
    private var qrCodeString: String?
    
    var callback: ((String) -> Void)?
    
    private var animationLayer: CALayer?
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard (captureSession?.isRunning ?? false) == false else { return }

        if !isConfigured {
            configureQRCodeReader()
        }
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
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
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
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
        
        /// Captures only inside of reader square
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.metadataOutput.rectOfInterest = self.previewLayer.rectOfInterest
        }
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
}

// MARK: - CAAnimationDelegate
extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationLayer?.isHidden = true
        guard let qrCodeString else { return }
        callback?(qrCodeString)
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        animateLineToTop()
        if let metadataObject = metadataObjects.first,
           metadataObject.type == .qr {
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject
            guard let qrCodeString = readableObject?.stringValue else { return }
            self.qrCodeString = qrCodeString
        }
    }
}
