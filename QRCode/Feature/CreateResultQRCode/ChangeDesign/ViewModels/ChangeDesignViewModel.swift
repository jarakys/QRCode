//
//  ChangeDesignViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

final class ChangeDesignViewModel: BaseViewModel {
    @Published public var items = [ChangeDesignSectionModel(cellIdentifiers: QRCodeDesign.allCases.map({ SelectableQRCodeDesign(item: $0, isSelected: $0 == .default) }), sectionIdentifier: 1)]
    @Published public var selectedItem: SelectableQRCodeDesign?
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        super.init()
        selectedItem = items.first?.cellIdentifiers.first
    }
    
    public func didClick(on item: SelectableQRCodeDesign) {
        selectedItem?.isSelected = false
        selectedItem = item
        selectedItem?.isSelected = true
    }
    
    public func save() {
        guard let selectedItem else { 
            navigationSender.send(.back)
            return
        }
        communicationBus.send(.designChanged(model: QRCodeDesignModel(logo: selectedItem.item.logo, design: selectedItem.item.qrCodeDesign)))
        navigationSender.send(.back)
    }
    
    public func cancel() {
        navigationSender.send(.back)
    }
}
