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
                    .onTapGesture {
                        guard viewModel.createCount < Config.maxCreatesCount else { return }
                        viewModel.templateDidTap(item: model)
                    }
                
            default:
                SocialCell(model: model, isPremium: viewModel.isPremium)
                    .onTapGesture {
                        guard viewModel.isPremium || !model.type.forPremium else { return }
                        viewModel.templateDidTap(item: model)
                    }
            }
            
        }.sectionHeader { sectionIdentifier, kind, indexPath in
            section(sectionIdentifier: sectionIdentifier)
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
    
    @ViewBuilder
    private func section(sectionIdentifier: CreateQRSectionType) -> some View {
        if sectionIdentifier == .personal {
            Text(sectionIdentifier.description.uppercased())
                .foregroundStyle(.sectionTitle)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
        } else {
            Text(sectionIdentifier.description.uppercased())
                .foregroundStyle(.sectionTitle)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    CreateView(viewModel: CreateViewModel(navigationSender: PassthroughSubject<CreateEventFlow, Never>()))
}
