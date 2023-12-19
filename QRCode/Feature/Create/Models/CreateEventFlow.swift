//
//  CreateEventFlow.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation

enum CreateEventFlow {
    case selection
    case create(type: CreateQRCodeTemplateModel)
    case result(finalString: String)
    case premium
    case back
    case popToRoot
}
