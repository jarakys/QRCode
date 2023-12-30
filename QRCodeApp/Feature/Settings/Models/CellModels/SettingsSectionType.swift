//
//  SettingsSectionType.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
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
            return String(localized: "Premium")
            
        case .general:
            return String(localized: "General")
            
        case .settings:
            return String(localized: "Settings")
            
        case .contact:
            return String(localized: "Contact")
        }
    }
}
