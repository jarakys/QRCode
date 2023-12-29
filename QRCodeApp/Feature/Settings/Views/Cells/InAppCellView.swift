//
//  InAppCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct InAppCellView: View {
    let image: String
    let title: String
    let subtitle: String
    var body: some View {
        HStack {
            Image(image)
                .resizable()
            VStack(spacing: 0) {
                Spacer()
                Text(title)
                    .multilineTextAlignment(.center)
                Spacer()
                VStack {
                    Text(subtitle)
                        .padding(.vertical, 9)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .background(.primaryApp)
                .cornerRadius(10)
                
            }
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 15)
        .background(.white)
    }
}
