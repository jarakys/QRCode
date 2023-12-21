//
//  CreateResultQRCodeViewModel.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import Foundation
import Combine
import QRCode

import UIKit

final class CreateResultQRCodeViewModel: ObservableObject {
    private let qrCodeFormat: QRCodeFormat
    private let qrCodeString: String
    @Published public var items = [TitledCopyContainerViewModel]()
    
    public lazy var qrCodeDocument: QRCode.Document = { [unowned self] in
        let document = QRCode.Document(generator: QRCodeGenerator_External())
        document.utf8String = self.qrCodeString
        document.design = .default()
        return document
    }()
    
    public lazy var title: String = { [unowned self] in
        "QRCode · \(self.qrCodeFormat.description)"
    }()
    
    public lazy var dateString: String = { [unowned self] in
        "15.08.2023"
    }()
    
    init(qrCodeFormat: QRCodeFormat,
         qrCodeString: String) {
        self.qrCodeFormat = qrCodeFormat
        self.qrCodeString = qrCodeString
        createFormat()
    }
    
    private func createFormat() {
        let formatMatcher = FormatMatcher(patterns: QRCodeFormat.allCases.map({ $0.regexPattern }), items: QRCodeFormat.allCases)
        let format = formatMatcher.matchFormat(inputString: qrCodeString)
        guard let format else { return }
        
        let values = extractTelephone(inputString: "tel:1234567")
        print(values)
    }
    
    func extractTelephone(inputString: String) -> String? {
        let pattern = "tel:(.*?)"

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        guard let match = regex.firstMatch(in: inputString, options: [], range: NSRange(location: 0, length: inputString.utf16.count)) else {
            return nil
        }

        let groupIndex = 1  // Index of the capturing group
        let range = match.range(at: groupIndex)

        if range.location != NSNotFound, let swiftRange = Range(range, in: inputString) {
            return String(inputString[swiftRange])
        } else {
            return nil
        }
    }
    
    func extractValues(inputString: String, format: String) -> [String: String]? {
        let pattern = format
            .replacingOccurrences(of: "%@", with: "(.*?)")
            .replacingOccurrences(of: ";", with: "\\;") // Escape semicolons in the format

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        guard let match = regex.firstMatch(in: inputString, options: [], range: NSRange(location: 0, length: inputString.count)) else {
            return nil
        }

        var values: [String: String] = [:]

        for i in 1..<match.numberOfRanges {
            let range = match.range(at: i)
            if range.location != NSNotFound,
               let swiftRange = Range(range, in: inputString) {
                let value = String(inputString[swiftRange])
                values["%\(i)@"] = value
            }
        }

        return values
    }
}
