//
//  CreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine
import QRCode

import UIKit

final class CreateResultQRCodeViewModel: ObservableObject {
    private let qrCodeFormat: QRCodeFormat
    private let qrCodeString: String
    
    public lazy var qrCodeDocument: QRCode.Document = { [unowned self] in
        let document = QRCode.Document(generator: QRCodeGenerator_External())
        document.utf8String = self.qrCodeString
        document.design = .default()
        return document
    }()
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    init(qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
    }
}
