//
//  EditQRCodeContentViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

final class EditQRCodeContentViewModel: BaseViewModel {
    @Published public var items = [TextViewModel]()
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    
    init(items: [TextViewModel],
         navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>) {
        self.items = items
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
    }
    
    public func save() {
        communicationBus.send(.contentChanged(items: items.map({ TitledCopyContainerViewModel(title: $0.title, value: $0.text) })))
        navigationSender.send(.back)
    }
    
    public func cancel() {
        navigationSender.send(.back)
    }
}
