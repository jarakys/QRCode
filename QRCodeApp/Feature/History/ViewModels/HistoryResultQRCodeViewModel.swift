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
        self.path = qrCodeEntityModel.subtitle
    }
    
    override func saveQRCode() async {
        isSaved = true
        await MainActor.run(body: {
            isLoading = true
        })
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        do {
            let result = try await ImageUploader.upload(data: data)
            self.path = result
            isLoading = false
        } catch {
            await MainActor.run(body: {
                isLoading = false
            })
            print("ImageUploader.upload error \(error)")
        }
    }
}
