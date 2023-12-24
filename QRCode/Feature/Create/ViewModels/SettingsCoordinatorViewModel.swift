//
//  SettingsCoordinatorViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation
import Combine

final class SettingsCoordinatorViewModel: ObservableObject {
    public let navigationSender = PassthroughSubject<SettingsEventFlow, Never>()
    
    lazy var selectionViewModel: SettingsViewModel = { [unowned self] in
        SettingsViewModel(navigationSender: navigationSender)
    }()
}
