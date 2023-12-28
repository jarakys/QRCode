//
//  HistoryCreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation
import Combine

final class HistoryCreateResultQRCodeViewModel: CreateResultQRCodeViewModel {
    private let id: UUID
    
    override var isDeletable: Bool {
        true
    }
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>,
         localStorage: LocalStore,
         qrCodeFormat: QRCodeFormat,
         qrCodeString: String,
         id: UUID) {
        self.id = id
        super.init(navigationSender: navigationSender,
                   communicationBus: communicationBus,
                   localStorage: localStorage,
                   qrCodeFormat: qrCodeFormat,
                   qrCodeString: qrCodeString)
    }
    
    private func update() {
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        guard let path else { return }
        do {
            try localStorage.updateQRCode(id: id, path: path, qrCodeString: qrCodeString, image: data)
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
            try localStorage.deleteQRCode(id: id)
            navigationSender.send(.back)
        } catch {
            print("deleteDidTap error \(error)")
        }
    }
}
