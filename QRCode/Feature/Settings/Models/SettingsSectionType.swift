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
