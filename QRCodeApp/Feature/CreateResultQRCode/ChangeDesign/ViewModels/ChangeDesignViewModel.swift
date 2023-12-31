//
//  ChangeDesignViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

final class ChangeDesignViewModel: BaseViewModel {
    @Published public var items = [ChangeDesignSectionModel(cellIdentifiers: QRCodeDesign.allCases.map({ SelectableQRCodeDesign(isSelected: $0 == .default, item: $0) }), sectionIdentifier: 1)]
    @Published public var selectedItem: SelectableQRCodeDesign?
    @Published public var isPremium = false
    @Published public var showingSheet = false
    
    private let navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private let communicationBus: PassthroughSubject<ResultEventBus, Never>
    private let qrCodeString: String
    
    init(qrCodeString: String,
         navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        self.qrCodeString = qrCodeString
        super.init()
        selectedItem = items.first?.cellIdentifiers.first
    }
    
    public func didClick(on item: SelectableQRCodeDesign) {
        selectedItem?.isSelected = false
        selectedItem = item
        selectedItem?.isSelected = true
    }
    
    override func bind() {
        super.bind()
        SubscriptionManager.shared.$isPremium.assign(to: &$isPremium)
    }
    
    public func premium() {
        showingSheet = true
    }
    
    public func save() {
        guard let selectedItem else { 
            navigationSender.send(.back)
            return
        }
        navigationSender.send(.detailedChangeDesign(qrCodeString: qrCodeString, qrCodeDesign: selectedItem.item))
        communicationBus.send(.designChanged(model: QRCodeDesignModel(logo: selectedItem.item.logo, design: selectedItem.item.qrCodeDesign)))
    }
    
    public func cancel() {
        navigationSender.send(.back)
    }
}
