//
//  CreateResultQRCodeCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

final class CreateResultQRCodeCoordinatorViewModel: BaseViewModel {
    
    private let qrCodeFormat: QRCodeFormat
    private let qrCodeString: String
    
    public let navigationSender = PassthroughSubject<ResultEventFlow, Never>()
    private let communicationBus = PassthroughSubject<ResultEventBus, Never>()
    
    lazy var createResultQRCodeViewModel: CreateResultQRCodeViewModel = {
        CreateResultQRCodeViewModel(navigationSender: navigationSender,
                                    communicationBus: communicationBus,
                                    qrCodeFormat: qrCodeFormat,
                                    qrCodeString: qrCodeString)
    }()
    
    init(qrCodeFormat: QRCodeFormat, qrCodeString: String) {
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
    }
    
    public func editQRCodeContentViewModel(items: [TextViewModel]) -> EditQRCodeContentViewModel {
        EditQRCodeContentViewModel(items: items,
                                   navigationSender: navigationSender,
                                   communicationBus: communicationBus)
    }
    
    public func changeDesignViewViewModel() -> ChangeDesignViewModel {
        ChangeDesignViewModel(navigationSender: navigationSender,
                              communicationBus: communicationBus)
    }
    
}
