//
//  DetailedChangeDesignSectionModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 23.12.2023.
//

import Foundation
import CompositionalList

class DesignElementViewModel: SelectableItemViewModel<DesignElements> {
}

extension DesignElementViewModel: Hashable {
    static func == (lhs: DesignElementViewModel, rhs: DesignElementViewModel) -> Bool {
        lhs.item.hashValue == rhs.item.hashValue && lhs.isSelected == rhs.isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        isSelected.hash(into: &hasher)
        item.hash(into: &hasher)
    }
    
}

struct DetailedChangeDesignSectionModel: SectionIdentifierViewModel {
    var sectionIdentifier: DetailedChangDesignSectionType
    var cellIdentifiers: [DesignElementViewModel]
}
