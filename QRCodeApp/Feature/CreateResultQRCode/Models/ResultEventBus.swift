//
//  ResultEventBus.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import QRCode

enum ResultEventBus {
    case contentChanged(items: [TitledCopyContainerViewModel])
    case designChanged(model: QRCodeDesignModel)
    case detailedDesignSave(design: QRCode.Design, logo: QRCode.LogoTemplate?)
}
