//
//  SettingsValueStringCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct SettingsValueStringCellView: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(.primaryTitle)
            Spacer()
            Text(value)
                .font(.system(size: 17))
                .foregroundStyle(.secondaryTitle)
        }
        .background(.white)
    }
}
