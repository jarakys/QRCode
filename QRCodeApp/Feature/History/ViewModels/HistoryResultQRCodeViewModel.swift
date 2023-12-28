//
//  HistoryResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import Foundation

final class HistoryResultQRCodeViewModel: BaseResultQRCodeViewModel {
    override init(qrCodeString: String,
                  localStorage: LocalStore,
                  qrCodeFormat: QRCodeFormat?) {
        super.init(qrCodeString: qrCodeString, localStorage: localStorage, qrCodeFormat: qrCodeFormat)
    }
}
