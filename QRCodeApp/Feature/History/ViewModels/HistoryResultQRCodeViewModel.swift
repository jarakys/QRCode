//
//  HistoryResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation

final class HistoryResultQRCodeViewModel: BaseResultQRCodeViewModel {
    init(qrCodeString: String,
                  localStorage: LocalStore,
                  path: String?,
                  qrCodeFormat: QRCodeFormat?) {
        super.init(qrCodeString: qrCodeString, localStorage: localStorage, qrCodeFormat: qrCodeFormat)
        self.path = path
    }
    
    override func saveQRCode() async {
        isSaved = true
        isLoading = true
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        do {
            let result = try await ImageUploader.upload(data: data)
            self.path = result
            isLoading = false
        } catch {
            print("ImageUploader.upload error \(error)")
        }
    }
}
