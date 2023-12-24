//
//  SettingsCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct SettingsCellView: View {
    let model: SettingsItemModel
    var body: some View {
        HStack(spacing: 12) {
            Image(model.icon)
            Text(model.title)
                .font(.system(size: 16))
                .foregroundStyle(.primaryTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(ImageResource.rightArrowIcon)
        }
        .padding(.horizontal, 16)
    }
}
