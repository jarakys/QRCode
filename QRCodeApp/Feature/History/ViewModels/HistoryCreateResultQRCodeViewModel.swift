//
//  HistoryCreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation
import Combine
import QRCode

final class HistoryCreateResultQRCodeViewModel: CreateResultQRCodeViewModel {
    private let qrCodeEntityModel: QRCodeEntityModel
    
    override var isDeletable: Bool {
        true
    }
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>,
         localStorage: LocalStore,
         qrCodeFormat: QRCodeFormat,
         qrCodeString: String,
         qrCodeEntityModel: QRCodeEntityModel) {
        self.qrCodeEntityModel = qrCodeEntityModel
        var design = QRCode.Design.default()
        var logo: QRCode.LogoTemplate? = nil
        if let qrCodeData = qrCodeEntityModel.coreEntity.qrCodeData,
           let qrDoc = try? QRCode.Document.Create(jsonData: qrCodeData) {
            design = qrDoc.design
            logo = qrDoc.logoTemplate
        }
        super.init(navigationSender: navigationSender,
                   communicationBus: communicationBus,
                   localStorage: localStorage,
                   design: design,
                   logo: logo,
                   qrCodeFormat: qrCodeFormat,
                   qrCodeString: qrCodeString)
        qrCodeId = qrCodeEntityModel.id
    }
    
    override func deleteDidTap() {
        do {
            try localStorage.deleteQRCode(id: qrCodeEntityModel.id)
            navigationSender.send(.back)
        } catch {
            print("deleteDidTap error \(error)")
        }
    }
}
