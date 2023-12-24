//
//  SettingsItemProtocolEraser.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

@frozen public struct SettingsItemProtocolEraser: SettingsItemProtocol {
    let title: String
    let icon: String
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }
}
