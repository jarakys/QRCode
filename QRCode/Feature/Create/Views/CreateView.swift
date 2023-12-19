//
//  CreateView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import CompositionalList
import Combine

struct CreateView: View {
    @StateObject public var viewModel: CreateViewModel
    
    var body: some View {
        CompositionalList(viewModel.items) { model, indexPath in
            switch model.type {
            case .phone, .sms, .url, .email:
                PersonalCell(model: model)
                    .cornerRadius(12)
                
            default:
                SocialCell(model: model)
            }
            
        }.sectionHeader { sectionIdentifier, kind, indexPath in
            Text(sectionIdentifier.description.uppercased())
                .foregroundStyle(.sectionTitle)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .selectedItem { _ in
            
        }
        .customLayout(.composed(sections: viewModel.items))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Create")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    viewModel.premiumDidTap()
                }, label: {
                    Image(ImageResource.premiumIcon)
                })
            })
        })
    }
}

#Preview {
    CreateView(viewModel: CreateViewModel(navigationSender: PassthroughSubject<CreateEventFlow, Never>()))
}
