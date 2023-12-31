//
//  Collection+safe.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 31.12.2023.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
