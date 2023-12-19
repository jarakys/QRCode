//
//  QRCode.Design+designs.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import UIKit
import QRCode

extension QRCode.Design {
    static func `default`() -> QRCode.Design {
        let design = QRCode.Design()
        design.shape.eye = QRCode.EyeShape.Square()
        design.shape.onPixels = QRCode.PixelShape.Square()
        design.style.onPixels = QRCode.FillStyle.Solid(UIColor(named: "QRCodeDefaultColor")!.cgColor)
        design.shape.offPixels = QRCode.PixelShape.Square()
        design.style.offPixels = QRCode.FillStyle.Solid(UIColor.clear.cgColor)
        design.additionalQuietZonePixels = 1
        design.style.backgroundFractionalCornerRadius = 2
        return design
    }
}
