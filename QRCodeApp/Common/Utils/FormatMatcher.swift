//
//  FormatMatcher.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 21.12.2023.
//

import Foundation

class FormatMatcher {
    static func getFormat(value: String, types: [QRCodeFormat]) -> QRCodeFormat {
        var typesTmp = types.filter({ $0 != .text })
        typesTmp.append(.text)
        return typesTmp.first(where: { value.starts(with: $0.regexPattern) }) ?? .text
    }
}
