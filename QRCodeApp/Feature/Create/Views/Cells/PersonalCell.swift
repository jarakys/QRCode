//
//  PersonalCell.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct PersonalCell: View {
    public let model: CreateQRCodeTemplateModel
    
    var body: some View {
        HStack(spacing: 15) {
            Image(model.type.image)
            Text(model.type.description)
                .foregroundStyle(.cellTitle)
                .font(.system(size: 15))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 12)
        .background(.personalCellBackground)
    }
}
