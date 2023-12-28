//
//  HistoryResultQRCodeCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation

final class HistoryResultQRCodeCoordinatorViewModel: CreateResultQRCodeCoordinatorViewModel {
    override func createResultQRCodeViewModelCreation() -> CreateResultQRCodeViewModel {
        HistoryCreateResultQRCodeViewModel(navigationSender: navigationSender,
                                           communicationBus: communicationBus,
                                           localStorage: CoreDataManager.shared,
                                           qrCodeFormat: qrCodeFormat,
                                           qrCodeString: qrCodeString)
    }
}
