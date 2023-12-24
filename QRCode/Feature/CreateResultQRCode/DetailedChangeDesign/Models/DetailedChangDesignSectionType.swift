//
//  DetailedChangDesignSectionType.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 23.12.2023.
//

import Foundation

enum DetailedChangDesignSectionType: Hashable {
    case body
    case marker
    case logoMask
    case color
    
    var description: String {
        switch self {
        case .body:
            return String(localized: "Body")
            
        case .marker:
            return String(localized: "Marker")
            
        case .logoMask:
            return String(localized: "Logo")
            
        case .color:
            return String(localized: "Color")
        }
    }
}
