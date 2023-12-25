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
         navigationSender: PassthroughSubject<ScanEventFlow, Never>) {
        self.navigationSender = navigationSender
        super.init(qrCodeString: qrCodeString, qrCodeFormat: nil)
    }
}
