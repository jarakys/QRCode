//
//  HistoryFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import Foundation

enum HistoryFlow: Hashable {
    case details(item: QRCodeEntityModel)
    case editableDetails(item: QRCodeEntityModel)
}
