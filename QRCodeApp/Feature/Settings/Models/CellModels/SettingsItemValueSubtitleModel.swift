//
//  SettingsItemValueSubtitleModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

class SettingsItemValueSubtitleModel<T: Hashable>: SettingsItemValueSubtitleProtocol, ObservableObject {
    let title: String
    let icon: String
    @Published var value: T
    let subtitle: String
    
    init(title: String, icon: String, value: T, subtitle: String) {
        self.title = title
        self.icon = icon
        self.value = value
        self.subtitle = subtitle
    }
    
    static func == (lhs: SettingsItemValueSubtitleModel<T>, rhs: SettingsItemValueSubtitleModel<T>) -> Bool {
        lhs.value == rhs.value && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(title)
        hasher.combine(subtitle)
    }
}
