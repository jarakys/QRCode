//
//  CreateContentLinkViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

final class CreateContentLinkViewModel: BaseViewModel {
    @Published public var items = [TextViewModel]()
    public let navigationSender: PassthroughSubject<CreateEventFlow, Never>
    
    private let format: QRCodeFormat
    
    init(format: QRCodeFormat,
         navigationSender: PassthroughSubject<CreateEventFlow, Never>) {
        self.format = format
        self.navigationSender = navigationSender
        super.init()
        createFormat()
    }
    
    public func createDidTap() {
        let finalString = String(format: format.format, arguments: items.map({ $0.text }))
        navigationSender.send(.result(finalString: finalString, type: format))
    }
    
    private func createFormat() {
        switch format {
        case .phone:
            items.append(TextViewModel(title: String(localized: "Phone number"), placeholder: String(localized: "Phone"), example: nil, text: ""))
            
        case .email:
            items.append(TextViewModel(title: String(localized: "To"), placeholder: "user@gmail.com", example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "CC"), placeholder: "user@gmail.com", example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .sms:
            items.append(TextViewModel(title: String(localized: "Phone"), placeholder: String(localized: "Phone"), example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .url:
            items.append(TextViewModel(title: String(localized: "Link"), placeholder: "https:", example: String(localized: "Example:https:qrcode"), text: ""))
            
        case .text:
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .wifi:
            items.append(TextViewModel(title: String(localized: "Network name"), placeholder: String(localized: "Network"), example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Password"), placeholder: String(localized: "Password"), example: nil, text: ""))
            
        case .location:
            break
        case .telegram:
            break
        case .facebook:
            break
        case .instagram:
            break
        case .twitter:
            break
        case .whatsApp:
            break
        case .tikTok:
            break
        case .spotify:
            break
        case .snapchat:
            break
        }
    }
}