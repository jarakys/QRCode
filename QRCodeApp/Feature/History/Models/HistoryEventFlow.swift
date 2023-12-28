//
//  HistoryEventFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation

enum HistoryEventFlow {
    case details(model: QRCodeEntityModel)
    case editableDetails(model: QRCodeEntityModel)
    case create
    case scans
    case back
}
