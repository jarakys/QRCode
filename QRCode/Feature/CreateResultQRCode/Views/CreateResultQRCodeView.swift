//
//  CreateResultQRCodeView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI
import QRCode

struct CreateResultQRCodeView: View {
    @StateObject public var viewModel: CreateResultQRCodeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text(viewModel.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.createResultTitle)
                QRCodeDocumentUIView(document: viewModel.qrCodeDocument)
                    .frame(width: 240, height: 240)
                Text(viewModel.dateString)
                    .font(.system(size: 13))
                    .foregroundStyle(.titleTextField)
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        Image(ImageResource.changeDesignIcon)
                        Text("Change Design")
                            .font(.system(size: 16))
                            .foregroundStyle(.primaryTitle)
                        Spacer()
                        Text("Pro")
                            .font(.system(size: 17))
                            .foregroundStyle(.secondaryTextField)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    Divider()
                        .padding(.leading, 16)
                    HStack(spacing: 10) {
                        Image(ImageResource.editContentIcon)
                        Text("Edit content")
                            .font(.system(size: 16))
                            .foregroundStyle(.primaryTitle)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                }
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
            }
        }
        .contentMargins(.top, 16)
        .frame(maxWidth: .infinity)
        .background(.secondaryBackground)
        .navigationTitle("Creation Result")
        .padding(.top, 1)
    }
}

#Preview {
    CreateResultQRCodeView(viewModel: CreateResultQRCodeViewModel(qrCodeFormat: .telegram, qrCodeString: "tetet"))
}
