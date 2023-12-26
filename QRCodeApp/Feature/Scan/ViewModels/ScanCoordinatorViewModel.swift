//
//  ScanCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation
import Combine

final class ScanCoordinatorViewModel: BaseViewModel {
    public let navigationSender = PassthroughSubject<ScanEventFlow, Never>()
    
    lazy var scanViewModel: ScanViewModel = {
        ScanViewModel(navigationSender: navigationSender)
    }()
    
    public func scanResultQRCodeViewModel(qrCodeString: String) -> ScanResultQRCodeViewModel {
        ScanResultQRCodeViewModel(qrCodeString: qrCodeString, 
                                  localStorage: CoreDataManager.shared,
                                  navigationSender: navigationSender)
    }
}
