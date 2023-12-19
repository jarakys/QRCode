//
//  TextViewModel.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine

final class TextViewModel: ObservableObject {
    public let title: String
    public let example: String?
    public let placeholder: String
    @Published public var text: String
    
    init(title: String, placeholder: String, example: String?, text: String) {
        self.title = title
        self.placeholder = placeholder
        self.example = example
        self.text = text
    }
}
