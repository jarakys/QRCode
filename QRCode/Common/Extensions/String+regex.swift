//
//  String+regex.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 21.12.2023.
//

import Foundation

extension String {
    func extractValue(pattern: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
            
            if let match = regex.firstMatch(in: self, options: [], range: range) {
                let matchRange = Range(match.range(at: 1), in: self)!
                return String(self[matchRange])
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return nil
    }
    
    func extractValues(patterns: [String]) -> [String] {
        var values = [String]()
        patterns.forEach { pattern in
            guard let value = self.extractValue(pattern: pattern) else { return }
            values.append(value)
        }

        return values
    }
}
