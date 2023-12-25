//
//  TitledContainerView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct TitledContainerView: View {
    public let title: String
    public let value: String
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .foregroundStyle(.titleTextField)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(value)
                    .font(.system(size: 13))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.cellTitle)
                Image(ImageResource.copyIcon)
                    .padding(.trailing, 16)
            }
            .background(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
}
