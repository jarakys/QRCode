//
//  SocialCell.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct SocialCell: View {
    public let model: CreateQRCodeTemplateModel
    
    var body: some View {
        VStack(spacing: 8) {
            Image(model.type.image)
                .padding(.horizontal, 13)
            Text(model.type.description)
                .foregroundStyle(.cellTitle)
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}
