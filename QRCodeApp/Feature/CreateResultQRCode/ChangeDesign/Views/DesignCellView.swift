//
//  DesignCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct DesignCellView<T: DesignIconProtocol>: View {
    @StateObject var model: SelectableItemViewModel<T>
    @State var isPremium = false
    
    var body: some View {
        ZStack {
            Image(model.item.designIcon)
        }
        .padding(.all, 16)
        .background(.white)
        .cornerRadius(16)
        .overlay(content: {
            if !isPremium && model.item.isForPremium {
                ZStack(alignment: .topTrailing, content: {
                    Image(.lockContentIcon)
                        .frame(width: 21, height: 21, alignment: .topTrailing)
                        .padding(.bottom, 66)
                        .padding(.leading, 66)
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        })
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(model.isSelected ? .blue : .white, lineWidth: 2)
        )
        .onReceive(SubscriptionManager.shared.$isPremium, perform: { value in
            isPremium = value
        })
    }
}

#Preview {
    DesignCellView(model: .init(isSelected: false, item: QRCodeDesign.default))
}
