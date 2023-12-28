//
//  HistoryQrCodeCellView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import SwiftUI

struct HistoryQrCodeCellView: View {
    let model: QRCodeEntityModel
    var body: some View {
        HStack(spacing: 16) {
            if model.isCreated {
                Image(uiImage: UIImage(data: model.image)!)
                    .resizable()
                    .frame(width: 48, height: 48)
            } else {
                Image(model.qrCodeFormat.image)
                    .resizable()
                    .frame(width: 48, height: 48)
            }
            VStack {
                Text("Qr Code · \(model.qrCodeFormat.description)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primaryTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("model.subtitle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .background(.white)
    }
}
