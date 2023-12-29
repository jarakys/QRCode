//
//  HistoryResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation
import QRCode

final class HistoryResultQRCodeViewModel: BaseResultQRCodeViewModel {
    let qrCodeEntityModel: QRCodeEntityModel
    
    init(localStorage: LocalStore,
         qrCodeEntityModel: QRCodeEntityModel) {
        self.qrCodeEntityModel = qrCodeEntityModel
        var design = QRCode.Design.default()
        var logo: QRCode.LogoTemplate?
        if let qrCodeData = qrCodeEntityModel.coreEntity.qrCodeData,
           let qrDoc = try? QRCode.Document.Create(jsonData: qrCodeData) {
            design = qrDoc.design
            logo = qrDoc.logoTemplate
        }
        super.init(qrCodeString: qrCodeEntityModel.qrCodeString, localStorage: localStorage, design: design, logo: logo, qrCodeFormat: qrCodeEntityModel.qrCodeFormat)
    }
}
