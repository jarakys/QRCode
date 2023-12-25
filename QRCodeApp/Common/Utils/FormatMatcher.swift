//
//  FormatMatcher.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 21.12.2023.
//

import Foundation

class FormatMatcher<T> {
    private let root = TrieNode<T>()

    init(patterns: [String], items: [T]) {
        for item in patterns.enumerated() {
            root.insert(item.element, item: items[item.offset])
        }
    }

    func matchFormat(inputString: String) -> T? {
        var node = root
        var countItteration = 0
        for char in inputString {
            countItteration += 1
            print(countItteration)
            if let nextNode = node.children[char] {
                node = nextNode
            } else {
                break
            }
        }
        return node.item
    }
}

class TrieNode<T> {
    var children: [Character: TrieNode] = [:]
    var pattern: String?
    var item: T?

    init() {}

    func insert(_ pattern: String, item: T) {
        var node = self
        for char in pattern {
            if node.children[char] == nil {
                node.children[char] = TrieNode()
                node.children[char]?.pattern = pattern
                node.children[char]?.item = item
            }
            node = node.children[char]!
        }
        node.pattern = pattern
    }
}
