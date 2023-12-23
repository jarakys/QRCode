//
//  SettingsViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation

enum SettingsSectionType {
    case payment
    case general
    case settings
    case contact
    
    var description: String {
        switch self {
        case .payment:
            return "In App"
            
        case .general:
            return "General"
            
        case .settings:
            return "Settings"
            
        case .contact:
            return "Contact"
        }
    }
}

struct SettingsSectionModel<T: SettingsItemProtocol> {
    let type: SettingsSectionType
    let items: [any SettingsItemProtocol]
    var title: String {
        type.description
    }
}

protocol SettingsItemProtocol {
    var title: String { get }
    var icon: String { get }
}

protocol SettingsItemSubtitleProtocol: SettingsItemProtocol {
    var subtitle: String { get }
}

@frozen public struct SettingsItemProtocolEraser: SettingsItemProtocol {
    let title: String
    let icon: String
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}

protocol SettingsItemValueProtocol: SettingsItemProtocol {
    associatedtype T
    var value: T { get set }
}

protocol SettingsItemValueSubtitleProtocol: SettingsItemValueProtocol, SettingsItemSubtitleProtocol {
    var subtitle: String { get }
}

struct SettingsItemModel: SettingsItemProtocol {
    let title: String
    let icon: String
}

struct SettingsItemSubtitleModel: SettingsItemSubtitleProtocol {
    let title: String
    let subtitle: String
    let icon: String
}

struct SettingsItemValueModel<T>: SettingsItemValueProtocol {
    let title: String
    let icon: String
    var value: T
}

struct SettingsItemValueSubtitleModel<T>: SettingsItemValueSubtitleProtocol {
    let title: String
    let icon: String
    var value: T
    let subtitle: String
}

final class SettingsViewModel: ObservableObject {
    @Published public var sections: [SettingsSectionModel<SettingsItemProtocolEraser>]
    
    init(sections: [SettingsSectionModel<SettingsItemModel>]) {
        self.sections = [
            SettingsSectionModel(type: .payment, items: [
                SettingsItemSubtitleModel(title: "Get unlimited access to all functions of the app", subtitle: "Try for free", icon: "")
            ]),
            SettingsSectionModel(type: .general, items: [
                SettingsItemValueModel(title: "License", icon: "licenseIcon", value: "Free"),
                SettingsItemValueModel(title: "QR scans remaining ", icon: "remainIcon", value: "3 of 5"),
                SettingsItemValueModel(title: "Products scans remaining", icon: "remainIcon", value: "3 of 5")
            ]),
            SettingsSectionModel(type: .settings, items: [
                SettingsItemValueSubtitleModel(title: "Vibrate", icon: "vibrationIcon", value: true, subtitle: "Vibrate when QR is found"),
                SettingsItemValueSubtitleModel(title: "Beep", icon: "beepIcon", value: true, subtitle: "Vibrate when QR is found"),
                SettingsItemValueModel(title: "Language", icon: "languageIcon", value: "English")
            ]),
            SettingsSectionModel(type: .contact, items: [
                SettingsItemModel(title: "About us", icon: "aboutIcon"),
                SettingsItemModel(title: "Terms and conditions", icon: "termsConditionIcon"),
                SettingsItemModel(title: "Privacy Policy", icon: "privacyPolicyIcon")
            ])
        ]
    }
}
