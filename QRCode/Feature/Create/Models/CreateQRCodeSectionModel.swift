//
//  CreateQRCodeSectionModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import Foundation
import CompositionalList

public enum CreateQRSectionType {
    case personal
    case utilities
    case social
}

public struct CreateQRCodeSectionModel: SectionIdentifierViewModel {
    public let cellIdentifiers: [CreateQRCodeTemplateModel]
    public let sectionIdentifier: CreateQRSectionType
}
