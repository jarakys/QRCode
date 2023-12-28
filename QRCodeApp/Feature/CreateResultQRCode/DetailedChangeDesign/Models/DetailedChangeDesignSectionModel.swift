//
//  DetailedChangeDesignSectionModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 23.12.2023.
//

import Foundation
import CompositionalList

struct DetailedChangeDesignSectionModel: SectionIdentifierViewModel {
    var sectionIdentifier: DetailedChangDesignSectionType
    var cellIdentifiers: [DesignElementViewModel]
}
