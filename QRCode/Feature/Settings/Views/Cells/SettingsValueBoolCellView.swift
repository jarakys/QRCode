//
//  SettingsValueBoolCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct SettingsValueBoolCellView: View {
    @ObservedObject public var model: SettingsItemValueSubtitleModel<Bool>
    var body: some View {
        HStack(spacing: 12) {
            Image(model.icon)
            VStack {
                Text(model.title)
                    .font(.system(size: 16))
                    .foregroundStyle(.primaryTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(model.subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.primaryTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            Toggle("", isOn: $model.value)
                .tint(.blue)
                .frame(width: 48)
        }
    }
}
