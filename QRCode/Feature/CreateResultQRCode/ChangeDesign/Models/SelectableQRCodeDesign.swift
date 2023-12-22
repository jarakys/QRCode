//
//  SelectableQRCodeDesign.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import Foundation
import Combine

class SelectableQRCodeDesign: ObservableObject {
    public var item: QRCodeDesign
    @Published public var isSelected: Bool
    
    init(item: QRCodeDesign, isSelected: Bool) {
        self.item = item
        self.isSelected = isSelected
    }
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
