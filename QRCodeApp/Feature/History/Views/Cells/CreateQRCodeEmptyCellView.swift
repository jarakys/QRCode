//
//  CreateQRCodeEmptyCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import SwiftUI

struct CreateQRCodeEmptyCellView: View {
    public var createDidTap: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Image(.emptyCreatedIcon)
            Text("Create QR Code")
                .foregroundStyle(.titleTextField)
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 22)
            Text("Let’s get started with your\nfirst QR creation:")
                .multilineTextAlignment(.center)
                .foregroundStyle(.subtitle)
                .font(.system(size: 15, weight: .semibold))
                .padding(.top, 4)
            Button(action: {
                createDidTap()
            }, label: {
                HStack {
                    Text("Create QR Code")
                        .foregroundStyle(.white)
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Image(.buttonScanIcon)
                }
            })
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(.primaryApp)
            .frame(width: 185)
            .cornerRadius(10)
            .padding(.top, 14)
        }
    }
}
