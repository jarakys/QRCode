//
//  BaseResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation
import Combine
import QRCode

class QRCodeContainer {
    static let document = QRCode.Document(generator: QRCodeGenerator_External())
}

class BaseResultQRCodeViewModel: BaseViewModel {
    @Published public var items = [TitledCopyContainerViewModel]()
    @Published private(set) var qrCodeDocument: QRCode.Document
    public let qrCodeFormat: QRCodeFormat
    public var qrCodeString: String
    
    public var eventSender = PassthroughSubject<CreateResultQRCodeViewModel.Event, Never>()
    
    private(set) var localStorage: LocalStore
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    public let design: QRCode.Design
    
    init(qrCodeString: String,
         localStorage: LocalStore,
         design: QRCode.Design = .default(),
         logo: QRCode.LogoTemplate? = nil,
         qrCodeFormat: QRCodeFormat?) {
        let formatMatcher = FormatMatcher(patterns: QRCodeFormat.allCases.map({ $0.regexPattern }), items: QRCodeFormat.allCases)
        self.qrCodeFormat = qrCodeFormat ?? formatMatcher.matchFormat(inputString: qrCodeString) ?? .text
        self.qrCodeString = qrCodeString
        self.qrCodeDocument = QRCode.Document(generator: QRCodeGenerator_External())
        self.localStorage = localStorage
        self.design = design
        super.init()
        createFormat()
        qrCodeDocument.utf8String = self.qrCodeString
        qrCodeDocument.design = design
        qrCodeDocument.logoTemplate = logo
    }
    
    public func share() {
        guard let data = qrCodeDocument.uiImage(.init(width: 240, height: 240))?.pngData() else { return }
        ShareActivityManager.share(datas: [ShareItemModel(item: data, title: "QRCode · \(qrCodeFormat.description)")])
    }
    
    public func shareInSafary(completion: @escaping (String) -> Void) {
//        completion(path)
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
    
    public func saveQRCode() async {
        fatalError("Not implemented")
    }
    
    @discardableResult
    public func addQRCode(isCreated: Bool, path: String) -> UUID? {
        guard let date = qrCodeDocument.uiImage(.init(width: 250, height: 250))?.pngData() else { return nil }
        guard let documentData = try? qrCodeDocument.jsonData() else { return nil }
        do {
            return try localStorage.addQRCode(qrCodeString: qrCodeString,
                                       type: qrCodeFormat.rawValue,
                                       subtitle: path,
                                       date: Date(),
                                       image: date, 
                                       qrCodeData: documentData,
                                       isCreated: isCreated)
            print("addQRCode added")
        } catch {
            print("addQRCode error \(error)")
            return nil
        }
    }
}
