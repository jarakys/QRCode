//
//  ResultEventBus.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation

enum ResultEventBus {
    case contentChanged(items: [TitledCopyContainerViewModel])
}
