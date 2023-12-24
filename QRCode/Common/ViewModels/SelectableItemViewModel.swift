//
//  SelectableItemViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

class SelectableItemViewModel<T>: ObservableObject {
    @Published public var isSelected: Bool
    public var item: T
    
    init(isSelected: Bool, item: T) {
        self.isSelected = isSelected
        self.item = item
    }
}
