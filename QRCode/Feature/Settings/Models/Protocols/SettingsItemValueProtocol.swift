//
//  SettingsItemValueProtocol.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

protocol SettingsItemValueProtocol: SettingsItemProtocol {
    associatedtype T: Hashable
    var value: T { get set }
}
