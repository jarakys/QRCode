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
    @Published public var isPremium: Bool = false
    private let localStorageService: LocalStorageService = UserDefaultsService.shared
    private let keychainStorage = KeychainManager.shared
    private let subscriptionManager = SubscriptionManager.shared
    
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
    
    private var qrCodeScansRemains: SettingsItemValueModel<String> {
        let text = isPremium ? String(localized: "Unlimited") : "\(countScans) of \(Config.maxScansCount)"
        return SettingsItemValueModel(title: String(localized: "QR scans remaining"), icon: "remainIcon", value: text)
    }
    
    private var qrCodeCreationRemains: SettingsItemValueModel<String> {
        let text = isPremium ? String(localized: "Unlimited") : "\(countCreates) of \(Config.maxCreatesCount)"
        return SettingsItemValueModel(title: String(localized: "QR creates remaining"), icon: "remainIcon", value: text)
    }
    
    public var countScans: Int {
        var countScans = keychainStorage.get(key: .countScans, defaultValue: 0)
        countScans = countScans > Config.maxScansCount ? Config.maxScansCount : countScans
        return countScans
    }
    
    public var countCreates: Int {
        var countCreates = keychainStorage.get(key: .countCreates, defaultValue: 0)
        countCreates = countCreates > Config.maxCreatesCount ? Config.maxCreatesCount : countCreates
        return countCreates
    }
    
    private var currentLanguage: String {
        guard let preferredLanguage = Locale.preferredLanguages.first else { return "EnglishMock" }
        let language = Locale(identifier: preferredLanguage)
        guard let languageName = Locale.current.localizedString(forLanguageCode: language.language.languageCode?.identifier ?? "en") else { return "EnglishMock" }
        return languageName
    }
    
    public var firstSection: SettingsSectionModel<SettingsItemProtocolEraser>? {
        sections.first
    }
    
    init(navigationSender: PassthroughSubject<SettingsEventFlow, Never>,
         communicationBus: PassthroughSubject<SettingsEventBus, Never>) {
        self.navigationSender = navigationSender
        self.communicationBus = communicationBus
        super.init()
        configureSections(isPremium: isPremium)
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
        
        subscriptionManager.$isPremium.assign(to: &$isPremium)
        
        $isPremium.sink(receiveValue: { [weak self] value in
            guard let self else { return }
            configureSections(isPremium: value)
        }).store(in: &cancellable)
    }
    
    public func reconfigureOnAppear() {
        configureSections(isPremium: isPremium)
    }
    
    private func configureSections(isPremium: Bool) {
        self.sections = [
            SettingsSectionModel(type: .payment, items: [
                .inApp(SettingsItemSubtitleModel(title: String(localized: "Get unlimited access to all functions of the app"), subtitle: String(localized: "Try for free"), icon: "inAppIcon"))
            ]),
            SettingsSectionModel(type: .general, items: [
                .license(SettingsItemValueModel(title: String(localized: "License"), icon: "licenseIcon", value: String(localized: isPremium ? "Premium" : "Free"))),
                .qrScans(qrCodeScansRemains),
                .qrCreation(qrCodeCreationRemains)
            ]),
            SettingsSectionModel(type: .settings, items: [
                .vibrate(vibrationItem),
                .beep(beepItem),
                .language(SettingsItemValueModel(title: String(localized: "Language"), icon: "languageIcon", value: ""))
            ]),
            SettingsSectionModel(type: .contact, items: [
                .aboutUs(SettingsItemModel(title: String(localized: "About us"), icon: "aboutIcon")),
                .termsAndConditions(SettingsItemModel(title: String(localized: "Terms and conditions"), icon: "termsConditionIcon")),
                .privacyPolicy(SettingsItemModel(title: String(localized: "Privacy Policy"), icon: "privacyPolicyIcon"))
            ])
        ]
        guard isPremium else { return }
        sections.removeAll(where: { $0.type == .payment })
    }
    
    public func languageDidTap() {
        eventSender.send(.languageDidTap)
    }
    
    public func premiumDidTap() {
        
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
