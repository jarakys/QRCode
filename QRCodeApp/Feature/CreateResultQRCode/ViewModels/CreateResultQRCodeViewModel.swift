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
    
    public var isDeletable: Bool {
        false
    }
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>,
         localStorage: LocalStore,
         qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        
        super.init(qrCodeString: qrCodeString, localStorage: localStorage, qrCodeFormat: qrCodeFormat)
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
    
    public func doneDidTap() {
        guard !isSaved else { 
            navigationSender.send(.backToMain)
            return
        }
        Task { @MainActor [weak self] in
            await self?.saveQRCode()
            self?.navigationSender.send(.backToMain)
        }
    }
    
    override func saveQRCode() async {
        isSaved = true
        await MainActor.run(body: {
            isLoading = true
        })
        guard let data = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        do {
            let result = try await ImageUploader.upload(data: data)
            self.path = result
            addQRCode(isCreated: true, path: result)
            let qrCodeCreatesCount = keychainStorage.get(key: .countCreates, defaultValue: 0)
            do {
                try keychainStorage.set(key: .countCreates, value: qrCodeCreatesCount + 1)
            } catch {
                print("CreateResultQRCodeViewModel keychainStorage countCreates error: \(error)")
            }
            await MainActor.run(body: {
                isLoading = false
            })
        } catch {
            await MainActor.run(body: {
                isLoading = false
            })
            print("ImageUploader.upload error \(error)")
        }
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
                
            case let .detailedDesignSave(design, logo):
                self.qrCodeDocument.design = design
                self.qrCodeDocument.logoTemplate = logo
                self.qrCodeDocument.setHasChanged()
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
