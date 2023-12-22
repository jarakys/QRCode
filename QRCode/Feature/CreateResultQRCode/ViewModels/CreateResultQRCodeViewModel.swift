//
//  CreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine
import QRCode

import UIKit

final class CreateResultQRCodeViewModel: ObservableObject {
    private let qrCodeFormat: QRCodeFormat
    private let qrCodeString: String
    @Published public var items = [TitledCopyContainerViewModel]()
    public var eventSender = PassthroughSubject<CreateResultQRCodeViewModel.Event, Never>()
    
    public lazy var qrCodeDocument: QRCode.Document = { [unowned self] in
        let document = QRCode.Document(generator: QRCodeGenerator_External())
        document.utf8String = self.qrCodeString
        document.design = .default()
        return document
    }()
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    init(qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
        createFormat()
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
