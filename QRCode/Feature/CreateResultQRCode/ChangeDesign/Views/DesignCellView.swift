//
//  DesignCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct DesignCellView: View {
    @StateObject var model: SelectableQRCodeDesign
    var body: some View {
        ZStack {
            Image(model.item.designIcon)
                .padding(.all, 16)
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
    DesignCellView(model: .init(item: .default, isSelected: false))
}
