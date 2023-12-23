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
            return "Body"
            
        case .marker:
            return "Marker"
            
        case .logoMask:
            return "Logo"
            
        case .color:
            return "Color"
        }
    }
}
