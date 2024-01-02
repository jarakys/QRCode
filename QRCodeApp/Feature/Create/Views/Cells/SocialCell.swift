//
//  SocialCell.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct SocialCell: View {
    public let model: CreateQRCodeTemplateModel
    @State public var isPremium = false
    
    var body: some View {
        VStack(spacing: 8) {
            Image(model.type.image)
                .padding(.horizontal, 13)
                .overlay(content: {
                    if !isPremium && model.type.forPremium {
                        ZStack(alignment: .topTrailing, content: {
                            Image(.lockContentIcon)
                                .frame(width: 21, height: 21, alignment: .topTrailing)
                                .padding(.bottom, 15)
                                .padding(.leading, 15)
                        })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                })
            Text(model.type.description)
                .foregroundStyle(.cellTitle)
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .onReceive(SubscriptionManager.shared.$isPremium, perform: { value in
            isPremium = value
        })
    }
}
