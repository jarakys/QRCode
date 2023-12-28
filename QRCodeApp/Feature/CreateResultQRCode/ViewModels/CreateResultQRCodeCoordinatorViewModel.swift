//
//  CreateResultQRCodeCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

class CreateResultQRCodeCoordinatorViewModel: BaseViewModel {
    
    public let qrCodeFormat: QRCodeFormat
    public let qrCodeString: String
    
    public let navigationSender = PassthroughSubject<ResultEventFlow, Never>()
    public let communicationBus = PassthroughSubject<ResultEventBus, Never>()
    
    lazy var createResultQRCodeViewModel: CreateResultQRCodeViewModel = {
        createResultQRCodeViewModelCreation()
    }()
    
    init(qrCodeFormat: QRCodeFormat, qrCodeString: String) {
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
    }
    
    public func createResultQRCodeViewModelCreation() -> CreateResultQRCodeViewModel {
        CreateResultQRCodeViewModel(navigationSender: navigationSender,
                                    communicationBus: communicationBus,
                                    localStorage: CoreDataManager.shared,
                                    qrCodeFormat: qrCodeFormat,
                                    qrCodeString: qrCodeString)
    }
    
    public func editQRCodeContentViewModel(items: [TextViewModel]) -> EditQRCodeContentViewModel {
        EditQRCodeContentViewModel(items: items,
                                   navigationSender: navigationSender,
                                   communicationBus: communicationBus)
    }
    
    public func changeDesignViewViewModel(qrCodeString: String) -> ChangeDesignViewModel {
        ChangeDesignViewModel(qrCodeString: qrCodeString,
                              navigationSender: navigationSender,
                              communicationBus: communicationBus)
    }
    
}
