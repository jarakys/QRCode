//
//  CreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine
import QRCode

final class CreateResultQRCodeViewModel: BaseViewModel {
    private let qrCodeFormat: QRCodeFormat
    private var qrCodeString: String
    @Published public var items = [TitledCopyContainerViewModel]()
    public var eventSender = PassthroughSubject<CreateResultQRCodeViewModel.Event, Never>()
    public var navigationSender: PassthroughSubject<ResultEventFlow, Never>
    public var communicationBus: PassthroughSubject<ResultEventBus, Never>
    
    @Published private(set) var qrCodeDocument: QRCode.Document
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    init(navigationSender: PassthroughSubject<ResultEventFlow, Never>,
         communicationBus: PassthroughSubject<ResultEventBus, Never>,
         qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
        qrCodeDocument = QRCode.Document(generator: QRCodeGenerator_External())
        super.init()
//        qrCodeDocument.logoTemplate = .()
        qrCodeDocument.utf8String = self.qrCodeString
        qrCodeDocument.design = .default()
        createFormat()
    }
    
    public func editContentDidTap() {
        navigationSender.send(.editContent(items: items
            .map({
                TextViewModel(title: $0.title, placeholder: "", example: nil, text: $0.value)
            })
        ))
    }
    
    public func changedDesignDidTap() {
        navigationSender.send(.changeDesign)
    }
    
    private func updateQRCodeDocument(qrCodeString: String) {
        qrCodeDocument.update(text: qrCodeString)
        qrCodeDocument.setHasChanged()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [unowned self] in
            objectWillChange.send()
        })
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
            }
        }).store(in: &cancellable)
    }
    
    private func createFormat() {
        let formatMatcher = FormatMatcher(patterns: QRCodeFormat.allCases.map({ $0.regexPattern }), items: QRCodeFormat.allCases)
        let format = formatMatcher.matchFormat(inputString: qrCodeString)
        guard let format else { return }
        let value =  qrCodeString.extractValues(patterns: format.regexExtract)
        
        switch format {
        case .email:
            items.append(TitledCopyContainerViewModel(title: "To", value: value[0]))
            items.append(TitledCopyContainerViewModel(title: "CC", value: value[1]))
            items.append(TitledCopyContainerViewModel(title: "Text", value: value[2]))
            
        case .sms:
            items.append(TitledCopyContainerViewModel(title: "Phone", value: value[0]))
            items.append(TitledCopyContainerViewModel(title: "Text", value: value[1]))
            
        case .url:
            items.append(TitledCopyContainerViewModel(title: "Link", value: value[0]))
            
        case .wifi:
            items.append(TitledCopyContainerViewModel(title: "Network name", value: value[0]))
            items.append(TitledCopyContainerViewModel(title: "Password", value: value[1]))
        
        case .phone:
            items.append(TitledCopyContainerViewModel(title: "Phone", value: value[0]))
            
        default: break
        }
    }
}

// Events
extension CreateResultQRCodeViewModel {
    enum Event {
        case copied
    }
}
