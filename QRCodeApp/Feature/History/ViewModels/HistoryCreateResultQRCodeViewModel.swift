//
//  HistoryCreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation
import Combine

final class HistoryCreateResultQRCodeViewModel: CreateResultQRCodeViewModel {
    override init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
                  communicationBus: PassthroughSubject<ResultEventBus, Never>,
                  localStorage: LocalStore,
                  qrCodeFormat: QRCodeFormat,
                  qrCodeString: String) {
        super.init(navigationSender: navigationSender,
                   communicationBus: communicationBus,
                   localStorage: localStorage,
                   qrCodeFormat: qrCodeFormat,
                   qrCodeString: qrCodeString)
    }
    
    override func doneDidTap() {
        
    }
}
