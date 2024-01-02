//
//  CreateContentLinkQRCodeView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI
import Combine

struct CreateContentLinkQRCodeView: View {
    @StateObject public var viewModel: CreateContentLinkViewModel
    var body: some View {
        VStack {
            TextFieldForm(items: viewModel.items)
            .scrollDismissesKeyboard(.interactively)
            .padding(.top, 1)
            Button(action: {
                viewModel.createDidTap()
            }, label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .padding(.vertical, 16)
                    .background(.primaryApp)
                    .cornerRadius(10)
                    .padding(.bottom, 24)
            })
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondaryBackground)
        .fullScreenCover(isPresented: $viewModel.showPremium, content: {
            PaywallView(viewModel: PaywallViewModel())
        })
    }
}

#Preview {
    CreateContentLinkQRCodeView(viewModel: CreateContentLinkViewModel(format: .phone, navigationSender: PassthroughSubject<CreateEventFlow, Never>()))
}
