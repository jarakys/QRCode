//
//  CreateCoordinatorViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

final class CreateCoordinatorViewModel: BaseViewModel {
    public let navigationSender = PassthroughSubject<CreateEventFlow, Never>()
    
    lazy var selectionViewModel: CreateViewModel = { [unowned self] in
        CreateViewModel(navigationSender: self.navigationSender)
    }()
    
    public func createViewModel(type: QRCodeFormat) -> CreateContentLinkViewModel {
        CreateContentLinkViewModel(format: type, navigationSender: navigationSender)
    }
    
    func createResultQRCodeCoordinatorViewModel(qrCodeFormat: QRCodeFormat, qrCodeString: String) -> CreateResultQRCodeCoordinatorViewModel {
        CreateResultQRCodeCoordinatorViewModel(qrCodeFormat: qrCodeFormat, qrCodeString: qrCodeString)
    }
}
