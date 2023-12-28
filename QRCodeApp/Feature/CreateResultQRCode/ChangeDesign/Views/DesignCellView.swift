//
//  DesignCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct DetailedChangeDesignCellView<T: DesignIconProtocol>: View {
    @StateObject var model: SelectableItemViewModel<T>
    var body: some View {
        ZStack {
            if let color = model.item.color {
                Image(model.item.designIcon)
                    .frame(width: 44, height: 44)
                    .padding(.all, 8)
                    .background(Color(color))
                    .cornerRadius(8)
            } else {
                Image(model.item.designIcon)
                    .frame(width: 44, height: 44)
                    .padding(.all, 8)
                    .background(.white)
                    .cornerRadius(8)
            }
        }
        .overlay(
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(model.isSelected ? .blue : .white, lineWidth: model.item.color != nil ? 0 : 2)
        )
    }
}

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
