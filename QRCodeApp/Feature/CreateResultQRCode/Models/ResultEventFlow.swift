//
//  ResultEventFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation

enum ResultEventFlow {
    case editContent(items: [TextViewModel])
    case back
    case backToMain
    case changeDesign(qrCodeString: String)
    case detailedChangeDesign(qrCodeString: String, qrCodeDesign: QRCodeDesign)
}
