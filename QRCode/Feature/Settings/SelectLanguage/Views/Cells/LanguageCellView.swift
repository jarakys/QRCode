//
//  LanguageCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct LanguageCellView: View {
    @StateObject public var model: LanguageModel
    var body: some View {
        HStack {
            Text(model.item.description)
                .font(.system(size: 16))
                .foregroundStyle(.primaryTitle)
            Spacer()
            Image(model.isSelected ? "selectedLanguageIcon" : "unselectedLanguageIcon")
        }
    }
}
