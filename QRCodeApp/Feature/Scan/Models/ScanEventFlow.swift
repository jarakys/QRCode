//
//  ScanEventFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation

enum ScanEventFlow {
    case result(qrCodeString: String)
    case back
}
