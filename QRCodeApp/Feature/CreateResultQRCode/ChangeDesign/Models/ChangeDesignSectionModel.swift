//
//  ChangeDesignSectionModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import CompositionalList

struct ChangeDesignSectionModel: SectionIdentifierViewModel {
    public let cellIdentifiers: [SelectableQRCodeDesign]
    public let sectionIdentifier: Int
}
