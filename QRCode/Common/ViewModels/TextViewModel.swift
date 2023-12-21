//
//  TextViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

final class TextViewModel: TitledContainerViewModel {
    public let placeholder: String
    public let example: String?
    @Published public var text: String
    
    init(title: String, placeholder: String, example: String?, text: String) {
        self.placeholder = placeholder
        self.text = text
        self.example = example
        super.init(title: title)
    }
}
