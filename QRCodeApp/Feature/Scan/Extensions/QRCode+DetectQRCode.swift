//
//  QRCode.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import UIKit
import QRCode

extension QRCode {
    static func DetectQRCode(data: Data) -> String? {
        QRCode.DetectQRCodes(in: UIImage(data: data)!)?.first?.messageString
    }
}
