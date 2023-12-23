//
//  SelectableQRCodeDesign.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

class SelectableItemViewModel<T>: ObservableObject {
    @Published public var isSelected: Bool
    public var item: T
    
    init(isSelected: Bool, item: T) {
        self.isSelected = isSelected
        self.item = item
    }
}

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
