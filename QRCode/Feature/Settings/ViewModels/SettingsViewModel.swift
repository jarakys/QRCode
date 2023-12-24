//
//  SettingsViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published public var sections: [SettingsSectionModel<SettingsItemProtocolEraser>]
    
    private let navigationSender: PassthroughSubject<SettingsEventFlow, Never>
    
    init(navigationSender: PassthroughSubject<SettingsEventFlow, Never>) {
        self.navigationSender = navigationSender
        self.sections = [
            SettingsSectionModel(type: .payment, items: [
                .inApp(SettingsItemSubtitleModel(title: "Get unlimited access to all functions of the app", subtitle: "Try for free", icon: "inAppIcon"))
                
            ]),
            SettingsSectionModel(type: .general, items: [
                .license(SettingsItemValueModel(title: "License", icon: "licenseIcon", value: "Free")),
                .qrScans(SettingsItemValueModel(title: "QR scans remaining ", icon: "remainIcon", value: "3 of 5")),
                .qrCreation(SettingsItemValueModel(title: "Products scans remaining", icon: "remainIcon", value: "3 of 5"))
            ]),
            SettingsSectionModel(type: .settings, items: [
                .vibrate(SettingsItemValueSubtitleModel(title: "Vibrate", icon: "vibrationIcon", value: true, subtitle: "Vibrate when QR is found")),
                .beep(SettingsItemValueSubtitleModel(title: "Beep", icon: "beepIcon", value: true, subtitle: "Vibrate when QR is found")),
                .language(SettingsItemValueModel(title: "Language", icon: "languageIcon", value: "English"))
            ]),
            SettingsSectionModel(type: .contact, items: [
                .aboutUs(SettingsItemModel(title: "About us", icon: "aboutIcon")),
                .termsAndConditions(SettingsItemModel(title: "Terms and conditions", icon: "termsConditionIcon")),
                .privacyPolicy(SettingsItemModel(title: "Privacy Policy", icon: "privacyPolicyIcon"))
            ])
        ]
    }
    
    public func vibrationDidTap() {
        
    }
    
    public func soundDidTap() {
        
    }
    
    public func languageDidTap() {
        navigationSender.send(.language)
    }
    
    public func aboutUsDidTap() {
        
    }
    
    public func privacyDidTap() {
        
    }
    
    public func termsOfUserDidTap() {
        
    }
}
