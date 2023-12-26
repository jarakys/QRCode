//
//  HistorySegmentType.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation

enum HistorySegmentType: Int {
    case scanned
    case created
    
    var description: String {
        switch self {
        case .scanned:
            return String(localized: "Scanned")
            
        case .created:
            return String(localized: "Created")
        }
    }
}
