//
//  LanguageType.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

enum LanguageType: String, CaseIterable {
    case english
    case englishUK
    case estonian
    case bangali
    case catalan
    case esperanto
    case chinese
    case arabic
    case bulgarian
    case dutch
    
    var description: String {
        switch self {
        case .english:
            return "EN"
            
        case .englishUK:
            return "UK"
            
        case .estonian:
            return "EST"
            
        case .bangali:
            return "BAN"
            
        case .catalan:
            return "CAT"
            
        case .esperanto:
            return "ESP"
            
        case .chinese:
            return "Ch"
            
        case .arabic:
            return "AR"
            
        case .bulgarian:
            return "BULG"
            
        case .dutch:
            return "DEU"
        }
    }
}
