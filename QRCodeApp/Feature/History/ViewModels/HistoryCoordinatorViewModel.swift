//
//  HistoryCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation
import Combine

final class HistoryCoordinatorViewModel: BaseViewModel {
    public let navigationSender = PassthroughSubject<HistoryEventFlow, Never>()
    
    public lazy var historyViewModel: HistoryViewModel = { [unowned self] in
        HistoryViewModel(subscriptionManager: SubscriptionManager.shared, navigationSender: navigationSender)
    }()
    
    public func historyResultQRCodeViewModel(model: QRCodeEntityModel) -> HistoryResultQRCodeViewModel {
        HistoryResultQRCodeViewModel(qrCodeString: model.qrCodeString, localStorage: CoreDataManager.shared, path: model.subtitle, qrCodeFormat: model.qrCodeFormat)
    }
    
    public func createResultQRCodeCoordinatorViewModel(model: QRCodeEntityModel) -> CreateResultQRCodeCoordinatorViewModel {
        HistoryResultQRCodeCoordinatorViewModel(id: model.id, qrCodeFormat: model.qrCodeFormat, qrCodeString: model.qrCodeString)
    }
}
