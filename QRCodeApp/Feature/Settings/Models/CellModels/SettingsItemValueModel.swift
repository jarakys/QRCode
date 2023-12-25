//
//  SettingsItemValueModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

class SettingsItemValueModel<T: Hashable>: SettingsItemValueProtocol, ObservableObject {
    let title: String
    let icon: String
    @Published var value: T
    
    init(title: String, icon: String, value: T) {
        self.title = title
        self.icon = icon
        self.value = value
    }
    
    static func == (lhs: SettingsItemValueModel<T>, rhs: SettingsItemValueModel<T>) -> Bool {
        lhs.value == rhs.value && lhs.title == rhs.title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(title)
    }
}
