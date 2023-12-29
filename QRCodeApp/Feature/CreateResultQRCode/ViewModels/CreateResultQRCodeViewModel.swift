//
//  CreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine
import QRCode

class CreateResultQRCodeViewModel: BaseResultQRCodeViewModel {
    public var navigationSender: PassthroughSubject<ResultEventFlow, Never>
    private var communicationBus: PassthroughSubject<ResultEventBus, Never>
    
    public let keychainStorage = KeychainManager.shared
    
    public var qrCodeId: UUID?
    
    public var isDeletable: Bool {
        false
    }
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>,
         localStorage: LocalStore,
         design: QRCode.Design = .default(),
         logo: QRCode.LogoTemplate? = nil,
         qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        super.init(qrCodeString: qrCodeString, localStorage: localStorage, design: design, logo: logo, qrCodeFormat: qrCodeFormat)
        qrCodeAdd()
    }
    
    public func qrCodeAdd() {
        qrCodeId = addQRCode(isCreated: true, path: "")
        let qrCodeCreatesCount = keychainStorage.get(key: .countCreates, defaultValue: 0)
        do {
            try keychainStorage.set(key: .countCreates, value: qrCodeCreatesCount + 1)
        } catch {
            print("CreateResultQRCodeViewModel keychainStorage countCreates error: \(error)")
        }
    }
    
    public func editContentDidTap() {
        navigationSender.send(.editContent(items: items
            .map({
                TextViewModel(title: $0.title, placeholder: "", example: nil, text: $0.value)
            })
        ))
    }
    
    public func changedDesignDidTap() {
        navigationSender.send(.changeDesign(qrCodeString: qrCodeString))
    }
    
    private func updateQRCodeDocument(qrCodeString: String) {
        qrCodeDocument.update(text: qrCodeString)
        qrCodeDocument.utf8String = qrCodeString
        qrCodeDocument.setHasChanged()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [unowned self] in
            objectWillChange.send()
        })
    }
    
    public func deleteDidTap() {
        
    }
    
    public func update() {
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        guard let qrCodeData = try? qrCodeDocument.jsonData() else { return }
        guard let qrCodeId else { return }
        do {
            try localStorage.updateQRCode(id: qrCodeId, path: "", qrCodeString: qrCodeString, image: data, qrCodeData: qrCodeData)
        } catch {
            print("doneDidTap error \(error)")
        }
    }
    
    override func bind() {
        super.bind()
        
        communicationBus.sink(receiveValue: { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .contentChanged(let items):
                self.items = items
                self.qrCodeString = String(format: qrCodeFormat.format, arguments: items.map({ $0.value }))
                self.updateQRCodeDocument(qrCodeString: self.qrCodeString)
                
            case let .designChanged(model):
                self.qrCodeDocument.design = model.design
                self.qrCodeDocument.logoTemplate = model.logo
                self.qrCodeDocument.setHasChanged()
                self.update()
                
            case let .detailedDesignSave(design, logo):
                self.qrCodeDocument.design = design
                self.qrCodeDocument.logoTemplate = logo
                self.qrCodeDocument.setHasChanged()
                self.update()
            }
        }).store(in: &cancellable)
    }
}

// Events
extension CreateResultQRCodeViewModel {
    enum Event {
        case copied
    }
}
