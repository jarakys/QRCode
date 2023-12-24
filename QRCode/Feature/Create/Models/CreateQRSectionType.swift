//
//  CreateQRSectionType.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation

public enum CreateQRSectionType {
    case personal
    case utilities
    case social
    
    var description: String {
        switch self {
        case .personal:
            return String(localized: "Personal")
            
        case .utilities:
            return String(localized: "Utilities")
            
        case .social:
            return String(localized: "Social")
        }
    }
}
