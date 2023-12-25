//
//  ViewController.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import QRCodeDetector
import UIKit

import SwiftUI

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
    let detector = QRCodeDetector.VideoDetector()
    var previewLayer: CALayer?
    var callback: ((String) -> Void)?
    
    public var isDetected = false
    public var isRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isDetected = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDetected = false

        guard !isRunning else { return }
        do {
            try self.detector.startDetecting { [weak self] _, features in
                self?.updateForQRCodes(features)
            }
            isRunning = true
        }
        catch {
            Swift.print("Could not start video capture (error: \(error))")
            Swift.print("Note that the simulator does not have a video capture device, so you need to run this on a 'real' device")
            fatalError()
        }

        let pl = try! self.detector.makePreviewLayer()
        pl.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(pl)
        pl.frame = self.view.layer.bounds
        self.previewLayer = pl
    }

    func updateForQRCodes(_ features: [CIQRCodeFeature]) {
        Swift.print("\(features.count) QR code(s) detected ")
        guard !isDetected else { return }
        guard let previewLayer = previewLayer else { return }
        features.forEach { feature in
            DispatchQueue.main.async {
                self.callback?(feature.messageString ?? "")
                self.isDetected = true
            }
            Swift.print("- \(feature.messageString ?? ""), bounds=\(feature.bounds)")
        }
    }
}
