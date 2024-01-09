//
//  DetailedChangeDesignCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 29.12.2023.
//

import SwiftUI

struct DetailedChangeDesignCellView<T: DesignIconProtocol>: View {
    @StateObject var model: SelectableItemViewModel<T>
    @State var isPremium = SubscriptionManager.shared.isPremium
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
        .overlay(content: {
            if !isPremium && model.item.isForPremium {
                ZStack(alignment: .topTrailing, content: {
                    Image(.lockContentIcon)
                        .frame(width: 21, height: 21, alignment: .topTrailing)
                        .padding(.bottom, 30)
                        .padding(.leading, 30)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        })
        .onReceive(SubscriptionManager.shared.$isPremium.dropFirst(), perform: { value in
            isPremium = value
        })
    }
}
