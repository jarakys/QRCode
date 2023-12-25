//
//  SettingsSectionModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

struct SettingsSectionModel<T: SettingsItemProtocol> {
    let type: SettingsSectionType
    let items: [SettingsItemType]
    var title: String {
        type.description
    }
}
