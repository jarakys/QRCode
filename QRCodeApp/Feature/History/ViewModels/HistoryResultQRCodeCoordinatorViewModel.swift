//
//  HistoryResultQRCodeCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation

final class HistoryResultQRCodeCoordinatorViewModel: CreateResultQRCodeCoordinatorViewModel {
    private let qrCodeEntityModel: QRCodeEntityModel
    
    init(qrCodeEntityModel: QRCodeEntityModel) {
        self.qrCodeEntityModel = qrCodeEntityModel
        super.init(qrCodeFormat: qrCodeEntityModel.qrCodeFormat, qrCodeString: qrCodeEntityModel.qrCodeString)
    }
    
    override func createResultQRCodeViewModelCreation() -> CreateResultQRCodeViewModel {
        HistoryCreateResultQRCodeViewModel(navigationSender: navigationSender,
                                           communicationBus: communicationBus,
                                           localStorage: CoreDataManager.shared,
                                           qrCodeFormat: qrCodeFormat,
                                           qrCodeString: qrCodeString, 
                                           qrCodeEntityModel: qrCodeEntityModel)
    }
}
