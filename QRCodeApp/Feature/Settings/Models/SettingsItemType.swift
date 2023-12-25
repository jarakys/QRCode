//
//  SettingsItemType.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

enum SettingsItemType: Hashable {
    case inApp(SettingsItemSubtitleModel)
    case license(SettingsItemValueModel<String>)
    case qrScans(SettingsItemValueModel<String>)
    case qrCreation(SettingsItemValueModel<String>)
    case vibrate(SettingsItemValueSubtitleModel<Bool>)
    case beep(SettingsItemValueSubtitleModel<Bool>)
    case language(SettingsItemValueModel<String>)
    case aboutUs(SettingsItemModel)
    case termsAndConditions(SettingsItemModel)
    case privacyPolicy(SettingsItemModel)
}
