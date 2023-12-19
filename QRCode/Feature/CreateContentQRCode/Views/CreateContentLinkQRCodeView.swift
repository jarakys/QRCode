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
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.items, id: \.title) { item in
                        TitledTextField(title: item.title, placeholder: item.placeholder, example: item.example, text: .init(get: {
                            item.text
                        }, set: { text in
                            item.text = text
                        }))
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .contentMargins(.top, 32, for: .scrollContent)
            .padding(.top, 1)
            Button(action: {
                viewModel.createDidTap()
            }, label: {
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundStyle(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .background(.primary)
                    .cornerRadius(10)
                    .padding(.bottom, 24)
            })
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondaryBackground)
    }
}

#Preview {
    CreateContentLinkQRCodeView(viewModel: CreateContentLinkViewModel(format: .phone, navigationSender: PassthroughSubject<CreateEventFlow, Never>()))
}
