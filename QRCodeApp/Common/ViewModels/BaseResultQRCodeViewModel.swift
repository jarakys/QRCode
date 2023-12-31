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
        self.qrCodeFormat = qrCodeFormat ?? FormatMatcher.getFormat(value: qrCodeString, types: QRCodeFormat.allCases)
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
    
    public func shareIn(completion: @escaping (String) -> Void) {
        completion(qrCodeString)
    }
    
    public func createFormat() {
        switch qrCodeFormat {
        case .email:
            var mail = mailtoConfigStringToDictionary(qrCodeString)
            
            items.append(TitledCopyContainerViewModel(title: String(localized: "To"), value: mail["to"] ?? ""))
            items.append(TitledCopyContainerViewModel(title: String(localized: "CC"), value: mail["cc"] ?? ""))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: mail["body"] ?? ""))
            
        case .sms:
            let sms = smstoConfigStringToDictionary(qrCodeString)
            items.append(TitledCopyContainerViewModel(title: String(localized: "Phone"), value: sms["to"] ?? ""))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: sms["body"] ?? ""))
            
        case .wifi:
            let wifi = wifiConfigStringToDictionary(qrCodeString)
            
            items.append(TitledCopyContainerViewModel(title: String(localized: "Network name"), value: wifi["s"] ?? ""))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Password"), value: wifi["p"] ?? ""))
        
        case .phone:
            let value =  qrCodeString.extractValues(patterns: qrCodeFormat.regexExtract)
            items.append(TitledCopyContainerViewModel(title: String(localized: "Phone"), value: value[0]))
            
        case .text:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Text"), value: qrCodeString))
            
        case .location:
            let geo = geoConfigStringToDictionary(qrCodeString)
            items.append(TitledCopyContainerViewModel(title: String(localized: "Latitude"), value: geo["latitude"] ?? ""))
            items.append(TitledCopyContainerViewModel(title: String(localized: "Longitude"), value: geo["longitude"] ?? ""))
            
        case .url:
            let url = urlConfigStringToDictionary(qrCodeString)
            items.append(TitledCopyContainerViewModel(title: String(localized: "Link"), value: url["url"] ?? ""))
            
        case .facebook, .tikTok, .snapchat, .instagram, .twitter, .spotify, .telegram, .whatsApp:
            items.append(TitledCopyContainerViewModel(title: String(localized: "Link"), value: qrCodeString))
            
        }
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


// Extraction

extension BaseResultQRCodeViewModel {
    func geoConfigStringToDictionary(_ configString: String) -> [String: String] {
        var geoDictionary: [String: String] = [:]

        if configString.hasPrefix("geo:") {
            // Remove "geo:" prefix
            let strippedString = String(configString.dropFirst(4))

            // Split by ","
            let components = strippedString.components(separatedBy: ",")

            if components.count == 2 {
                geoDictionary["latitude"] = components[safe: 0] ?? ""
                geoDictionary["longitude"] = components[safe: 1] ?? ""
            }
        }

        return geoDictionary
    }
    
    func smstoConfigStringToDictionary(_ configString: String) -> [String: String] {
        var smstoDictionary: [String: String] = [:]

        if configString.hasPrefix("smsto:") {
            // Remove "smsto:" prefix
            let strippedString = String(configString.dropFirst(6))

            // Split by ":"
            let components = strippedString.components(separatedBy: ":")

            if components.count == 2 {
                smstoDictionary["to"] = components[safe: 0] ?? ""
                smstoDictionary["body"] = components[safe: 1] ?? ""
            }
        }

        return smstoDictionary
    }
    
    func wifiConfigStringToDictionary(_ configString: String) -> [String: String] {
        var wifiDictionary: [String: String] = [:]

        let strippedString = String(configString.dropFirst(5))
        let components = strippedString.components(separatedBy: ";")

        for component in components {
            let keyValueComponents = component.components(separatedBy: ":")
            if keyValueComponents.count == 2 {
                let key = keyValueComponents[safe: 0] ?? ""
                let value = keyValueComponents[safe: 1] ?? ""
                wifiDictionary[key.lowercased()] = value
            }
        }

        return wifiDictionary
    }
    
    func mailtoConfigStringToDictionary(_ configString: String) -> [String: String] {
        var mailtoDictionary: [String: String] = [:]

        if configString.hasPrefix("mailto:") {
            // Remove "mailto:" prefix
            let strippedString = String(configString.dropFirst(7))

            // Split by "&"
            let components = strippedString.components(separatedBy: "&")

            for component in components {
                let keyValueComponents = component.components(separatedBy: "=")
                if keyValueComponents.count == 2 {
                    let key = keyValueComponents[safe: 0] ?? ""
                    let value = keyValueComponents[safe: 1] ?? ""
                    mailtoDictionary[key.lowercased()] = value
                } else if keyValueComponents.count == 1 {
                    // If there's only one component, consider it as the "to" address
                    mailtoDictionary["to"] = keyValueComponents[safe: 0] ?? ""
                }
            }
        }

        return mailtoDictionary
    }
    
    func urlConfigStringToDictionary(_ configString: String) -> [String: String] {
        var urlDictionary: [String: String] = [:]

        if configString.hasPrefix("url:") {
            // Remove "url:" prefix
            let strippedString = String(configString.dropFirst(4))
            
            urlDictionary["url"] = strippedString
        }

        return urlDictionary
    }
}
