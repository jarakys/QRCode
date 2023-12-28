//
//  ScanResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation
import Combine

final class ScanResultQRCodeViewModel: BaseResultQRCodeViewModel {
    private let navigationSender: PassthroughSubject<ScanEventFlow, Never>
    
    init(qrCodeString: String,
         localStorage: LocalStore,
         navigationSender: PassthroughSubject<ScanEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init(qrCodeString: qrCodeString, localStorage: localStorage, qrCodeFormat: nil)
        addQRCode(isCreated: false, path: "")
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
            await MainActor.run(body: {
                isLoading = false
            })
        } catch {
            await MainActor.run(body: {
                isLoading = false
            })
            print("ImageUploader.upload error \(error)")
        }
    }
}
