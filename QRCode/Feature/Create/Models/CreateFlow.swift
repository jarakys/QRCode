//
//  CreateFlow.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation

enum CreateFlow: Hashable {
    case selection
    case create(type: CreateQRCodeTemplateModel)
    case result(finalString: String, type: QRCodeFormat)
    case premium
}
