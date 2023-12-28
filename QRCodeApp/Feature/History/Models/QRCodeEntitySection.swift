//
//  QRCodeEntitySection.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation

class QRCodeEntitySection {
    public let title: String
    public var items: [QRCodeEntityModel]
    
    init(title: String, items: [QRCodeEntityModel]) {
        self.title = title
        self.items = items
    }
}
