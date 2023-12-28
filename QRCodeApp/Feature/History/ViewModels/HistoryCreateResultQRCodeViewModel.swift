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
    }
    
    private func update() {
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        guard let path else { return }
        guard let qrCodeData = try? qrCodeDocument.jsonData() else { return }
        do {
            try localStorage.updateQRCode(id: qrCodeEntityModel.id, path: path, qrCodeString: qrCodeString, image: data, qrCodeData: qrCodeData)
        } catch {
            print("doneDidTap error \(error)")
        }
    }
    
    override func doneDidTap() {
        guard !isSaved else {
            update()
            navigationSender.send(.back)
            return
        }
        Task {
            await saveQRCode()
            update()
            navigationSender.send(.back)
        }
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
    
    override func deleteDidTap() {
        do {
            try localStorage.deleteQRCode(id: qrCodeEntityModel.id)
            navigationSender.send(.back)
        } catch {
            print("deleteDidTap error \(error)")
        }
    }
}
