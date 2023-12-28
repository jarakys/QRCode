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
    
    override func doneDidTap() {
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        do {
            try localStorage.updateQRCode(id: id, qrCodeString: qrCodeString, image: data)
        } catch {
            print("doneDidTap error \(error)")
        }
        navigationSender.send(.back)
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
