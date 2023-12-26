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
        HistoryViewModel(navigationSender: navigationSender)
    }()
}
