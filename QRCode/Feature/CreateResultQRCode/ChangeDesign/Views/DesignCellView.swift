//
//  DesignCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct DesignCellView<T: DesignIconProtocol>: View {
    @StateObject var model: SelectableItemViewModel<T>
    var body: some View {
        ZStack {
            Image(model.item.designIcon)
                .padding(.all, 8)
        }
        .background(.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(model.isSelected ? .blue : .white, lineWidth: 2)
        )
    }
}

#Preview {
    DesignCellView(model: .init(isSelected: false, item: QRCodeDesign.default))
}
