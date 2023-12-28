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
        HistoryResultQRCodeViewModel(localStorage: CoreDataManager.shared, qrCodeEntityModel: model)
    }
    
    public func createResultQRCodeCoordinatorViewModel(model: QRCodeEntityModel) -> CreateResultQRCodeCoordinatorViewModel {
        HistoryResultQRCodeCoordinatorViewModel(qrCodeEntityModel: model)
    }
}
