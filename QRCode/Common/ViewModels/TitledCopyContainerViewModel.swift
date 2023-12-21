//
//  TitledCopyContainerViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 21.12.2023.
//

import Foundation

final class TitledCopyContainerViewModel: TitledContainerViewModel {
    public let value: String
    
    init(title: String, value: String) {
        self.value = value
        super.init(title: title)
    }
}
