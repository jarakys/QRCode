//
//  ScanQRCodeEmptyCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import SwiftUI

struct ScanQRCodeEmptyCellView: View {
    public var scanDidTap: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            Image(.emptyScanIcon)
            Text("Scan QR")
                .foregroundStyle(.titleTextField)
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 22)
            Text("Let’s get started with your\nfirst QR scan:")
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.subtitle)
                .padding(.top, 4)
            Button(action: {
                scanDidTap()
            }, label: {
                HStack {
                    Text("Scan QR Code")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
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
