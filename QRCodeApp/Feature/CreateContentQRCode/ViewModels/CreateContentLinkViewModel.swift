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
    @Published public var isPremium: Bool = false
    @Published public var showPremium = false
    public let navigationSender: PassthroughSubject<CreateEventFlow, Never>
    
    private let format: QRCodeFormat
    
    private var countCreates: Int {
        KeychainManager.shared.get(key: .countCreates, defaultValue: 0)
    }
    
    init(format: QRCodeFormat,
         navigationSender: PassthroughSubject<CreateEventFlow, Never>) {
        self.format = format
        self.navigationSender = navigationSender
        super.init()
        createFormat()
    }
    
    override func bind() {
        super.bind()
        
        SubscriptionManager.shared.$isPremium.assign(to: &$isPremium)
    }
    
    public func createDidTap() {
        guard !items.map({ $0.text }).joined().isEmpty else { return }
        guard isPremium || countCreates < Config.maxCreatesCount else {
            showPremium = true
            return
        }
        var items = items.map({ $0.text })
        if format == .wifi {
            items.insert("", at: 1)
            items.insert("", at: 3)
        }
        let finalString = String(format: format.format, arguments: items)
        guard !finalString.isEmpty, !finalString.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        navigationSender.send(.result(finalString: finalString, type: format))
    }
    
    private func createFormat() {
        switch format {
        case .phone:
            items.append(TextViewModel(title: String(localized: "Phone"), placeholder: String(localized: "Phone"), example: nil, text: ""))
            
        case .email:
            items.append(TextViewModel(title: String(localized: "To"), placeholder: "user@gmail.com", example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "CC"), placeholder: "user@gmail.com", example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .sms:
            items.append(TextViewModel(title: String(localized: "Phone"), placeholder: String(localized: "Phone"), example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .url:
            items.append(TextViewModel(title: String(localized: "Link"), placeholder: "https:", example: String(localized: "Example:https://qrscanread.com"), text: ""))
            
        case .text:
            items.append(TextViewModel(title: String(localized: "Text"), placeholder: String(localized: "tell us more details..."), example: nil, text: ""))
            
        case .wifi:
            items.append(TextViewModel(title: String(localized: "Name"), placeholder: String(localized: "Name"), example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Password"), placeholder: String(localized: "Password"), example: nil, text: ""))
            
        case .location:
            items.append(TextViewModel(title: String(localized: "Longitude"), placeholder: String(localized: "Longitude"), example: nil, text: ""))
            items.append(TextViewModel(title: String(localized: "Latitude"), placeholder: String(localized: "Latitude"), example: nil, text: ""))
            
        case .telegram:
            items.append(TextViewModel(title: String(localized: "Telegram"), placeholder: "Telegram url", example: nil, text: "https://t.me/"))
            
        case .facebook:
            items.append(TextViewModel(title: String(localized: "Facebook"), placeholder: "Facebook url", example: nil, text: "https://www.facebook.com/"))
            
        case .instagram:
            items.append(TextViewModel(title: String(localized: "Instagram"), placeholder: "Instagram url", example: nil, text: "https://www.instagram.com/"))
            
        case .twitter:
            items.append(TextViewModel(title: "X", placeholder: "Twitter url", example: nil, text: "https://twitter.com/"))
            
        case .whatsApp:
            items.append(TextViewModel(title: String(localized: "WhatsApp"), placeholder: "WhatsApp url", example: nil, text: "https://wa.me/qr/"))
            
        case .tikTok:
            items.append(TextViewModel(title: String(localized: "TikTok"), placeholder: "TikTok url", example: nil, text: "https://vm.tiktok.com/"))
            
        case .spotify:
            items.append(TextViewModel(title: String(localized: "Spotify"), placeholder: "Spotify url", example: nil, text: "https://open.spotify.com/"))

        case .snapchat:
            items.append(TextViewModel(title: String(localized: "Snapchat"), placeholder: "Snapchat url", example: nil, text: "https://snapchat.com/"))
        }
    }
}
