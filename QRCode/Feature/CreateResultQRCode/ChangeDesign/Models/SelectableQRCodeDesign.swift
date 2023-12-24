//
//  SelectableQRCodeDesign.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

class SelectableQRCodeDesign: SelectableItemViewModel<QRCodeDesign> {
}

extension SelectableQRCodeDesign: Hashable {
    static func == (lhs: SelectableQRCodeDesign, rhs: SelectableQRCodeDesign) -> Bool {
        lhs.item == rhs.item && rhs.isSelected == lhs.isSelected
    }
    
    func hash(into hasher: inout Hasher) {
        item.hash(into: &hasher)
        isSelected.hash(into: &hasher)
    }
}
