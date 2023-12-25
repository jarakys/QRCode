//
//  SettingsItemValueSubtitleProtocol.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

protocol SettingsItemValueSubtitleProtocol: SettingsItemValueProtocol, SettingsItemSubtitleProtocol {
    var subtitle: String { get }
}
