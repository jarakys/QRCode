//
//  SettingsViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import Combine

final class SettingsViewModel: BaseViewModel {
    @Published public var sections: [SettingsSectionModel<SettingsItemProtocolEraser>] = []
    private let localStorageService: LocalStorageService = UserDefaultsService.shared
    
    public let eventSender = PassthroughSubject<SettingsViewModel.Event, Never>()
    
    private let navigationSender: PassthroughSubject<SettingsEventFlow, Never>
    private let communicationBus: PassthroughSubject<SettingsEventBus, Never>
    
    private lazy var vibrationItem: SettingsItemValueSubtitleModel = { [unowned self] in
        let isSelected = self.localStorageService.get(key: .vibrationSelected, defaultValue: true)
        return SettingsItemValueSubtitleModel(title: String(localized: "Vibrate"), icon: "vibrationIcon", value: isSelected, subtitle: String(localized: "Vibrate when QR is found"))
    }()
    private lazy var beepItem: SettingsItemValueSubtitleModel = {
        let isSelected = self.localStorageService.get(key: .beepSelected, defaultValue: true)
        return SettingsItemValueSubtitleModel(title: String(localized: "Beep"), icon: "beepIcon", value: isSelected, subtitle: String(localized: "Vibrate when QR is found"))
    }()
    
    private lazy var qrCodeScansRemains: SettingsItemValueModel = {
        return SettingsItemValueModel(title: String(localized: "QR scans remaining"), icon: "remainIcon", value: "3 of 5")
    }()
    
    private lazy var qrCodeCreationRemains: SettingsItemValueModel = {
        return SettingsItemValueModel(title: String(localized: "Products scans remaining"), icon: "remainIcon", value: "3 of 5")
    }()
    
    init(navigationSender: PassthroughSubject<SettingsEventFlow, Never>,
         communicationBus: PassthroughSubject<SettingsEventBus, Never>) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        super.init()
        self.sections = [
            SettingsSectionModel(type: .payment, items: [
                .inApp(SettingsItemSubtitleModel(title: String(localized: "Get unlimited access to all functions of the app"), subtitle: String(localized: "Try for free"), icon: "inAppIcon"))
            ]),
            SettingsSectionModel(type: .general, items: [
                .license(SettingsItemValueModel(title: String(localized: "License"), icon: "licenseIcon", value: String(localized: "Free"))),
                .qrScans(qrCodeScansRemains),
                .qrCreation(qrCodeCreationRemains)
            ]),
            SettingsSectionModel(type: .settings, items: [
                .vibrate(vibrationItem),
                .beep(beepItem),
                .language(SettingsItemValueModel(title: String(localized: "Language"), icon: "languageIcon", value: "English"))
            ]),
            SettingsSectionModel(type: .contact, items: [
                .aboutUs(SettingsItemModel(title: String(localized: "About us"), icon: "aboutIcon")),
                .termsAndConditions(SettingsItemModel(title: String(localized: "Terms and conditions"), icon: "termsConditionIcon")),
                .privacyPolicy(SettingsItemModel(title: String(localized: "Privacy Policy"), icon: "privacyPolicyIcon"))
            ])
        ]
    }
    
    override func bind() {
        super.bind()
        vibrationItem.$value.dropFirst().sink(receiveValue: { [weak self] value in
            guard let self else { return }
            self.localStorageService.set(key: .vibrationSelected, value: value)
        }).store(in: &cancellable)
        
        beepItem.$value.dropFirst().sink(receiveValue: { [weak self] value in
            guard let self else { return }
            self.localStorageService.set(key: .beepSelected, value: value)
        }).store(in: &cancellable)
    }
    
    public func languageDidTap() {
        eventSender.send(.languageDidTap)
    }
    
    public func aboutUsDidTap() {
        
    }
    
    public func privacyDidTap() {
        
    }
    
    public func termsOfUserDidTap() {
        
    }
}

// MARK: Event

extension SettingsViewModel {
    enum Event {
        case languageDidTap
    }
}
