//
//  ResultFlow.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation

enum ResultFlow: Hashable {
    case editContent(items: [TextViewModel])
    case changeDesign
    case detailedChangeDesing
}
