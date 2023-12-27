//
//  BaseResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation
import Combine
import QRCode

class BaseResultQRCodeViewModel: BaseViewModel {
    @Published public var items = [TitledCopyContainerViewModel]()
    @Published private(set) var qrCodeDocument: QRCode.Document
    public let qrCodeFormat: QRCodeFormat
    public var qrCodeString: String
    
    public var eventSender = PassthroughSubject<CreateResultQRCodeViewModel.Event, Never>()
    
    private let localStorage: LocalStore
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    init(qrCodeString: String,
         localStorage: LocalStore,
         qrCodeFormat: QRCodeFormat?) {
        let formatMatcher = FormatMatcher(patterns: QRCodeFormat.allCases.map({ $0.regexPattern }), items: QRCodeFormat.allCases)
        self.qrCodeFormat = qrCodeFormat ?? formatMatcher.matchFormat(inputString: qrCodeString) ?? .text
        self.qrCodeString = qrCodeString
        self.qrCodeDocument = QRCode.Document(generator: QRCodeGenerator_External())
        self.localStorage = localStorage
        super.init()
        createFormat()
        qrCodeDocument.utf8String = self.qrCodeString
        qrCodeDocument.design = .default()
    }
    
    public func createFormat() {
        let value =  qrCodeString.extractValues(patterns: qrCodeFormat.regexExtract)
        
        switch qrCodeFormat {
        case .email:
            items.append(TitledCopyContainerViewModel(title: String(localized: "To"), value: value[0]))
            items.append(TitledCopyContainerViewModel(title: String(localized: "CC"), value: value[1]))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: value[2]))
            
        case .sms:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Phone"), value: value[0]))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: value[1]))
            
        case .url:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Link"), value: value[0]))
            
        case .wifi:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Network name"), value: value[0]))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Password"), value: value[1]))
        
        case .phone:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Phone"), value: value[0]))
            
        case .text:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: qrCodeString))
            
        default: break
        }
    }
    
    public func addQRCode(isCreated: Bool) {
        guard let date = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return }
        do {
            try localStorage.addQRCode(qrCodeString: qrCodeString,
                                       type: qrCodeFormat.rawValue,
                                       subtitle: "",
                                       date: Date(),
                                       image: date,
                                       isCreated: isCreated)
            print("addQRCode added")
        } catch {
            print("addQRCode error \(error)")
        }
    }
}
