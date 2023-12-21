//
//  TitledContainerViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 21.12.2023.
//

import Foundation

class TitledContainerViewModel: ObservableObject {
    public let title: String
    
    init(title: String) {
        self.title = title
    }
}
