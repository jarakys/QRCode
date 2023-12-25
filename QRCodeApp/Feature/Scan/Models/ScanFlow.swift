//
//  ScanFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation

enum ScanFlow: Hashable {
    case result(qrCodeString: String)
}
