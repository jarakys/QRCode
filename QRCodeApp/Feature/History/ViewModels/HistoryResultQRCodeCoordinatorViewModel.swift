//
//  HistoryResultQRCodeCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation

final class HistoryResultQRCodeCoordinatorViewModel: CreateResultQRCodeCoordinatorViewModel {
    private let id: UUID
    
    init(id: UUID, qrCodeFormat: QRCodeFormat, qrCodeString: String) {
        self.id = id
        super.init(qrCodeFormat: qrCodeFormat, qrCodeString: qrCodeString)
    }
    
    override func createResultQRCodeViewModelCreation() -> CreateResultQRCodeViewModel {
        HistoryCreateResultQRCodeViewModel(navigationSender: navigationSender,
                                           communicationBus: communicationBus,
                                           localStorage: CoreDataManager.shared,
                                           qrCodeFormat: qrCodeFormat,
                                           qrCodeString: qrCodeString, 
                                           id: id)
    }
}
