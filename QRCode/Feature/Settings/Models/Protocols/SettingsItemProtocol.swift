//
//  SettingsItemProtocol.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

protocol SettingsItemProtocol: Hashable {
    var title: String { get }
    var icon: String { get }
}

