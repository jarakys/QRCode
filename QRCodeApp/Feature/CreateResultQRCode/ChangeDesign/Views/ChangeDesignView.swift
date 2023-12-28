//
//  ChangeDesignView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI
import Combine
import CompositionalList
import QRCode

struct ChangeDesignView: View {
    @StateObject public var viewModel: ChangeDesignViewModel
    
    var body: some View {
        CompositionalList(viewModel.items) { model, indexPath in
            DesignCellView(model: model)
        }.sectionHeader { sectionIdentifier, kind, indexPath in
            EmptyView()
        }
        .selectedItem { item in
            viewModel.didClick(on: item)
        }
        .customLayout(.designChanged(sections: [1]))
        .background(.secondaryBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button("Cancel", action: {
                    viewModel.cancel()
                })
                .foregroundStyle(.tint)
                    
            })
            ToolbarItem(placement: .principal, content: {
                Text("Templates")
                    .font(.system(size: 17, weight: .semibold))
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("Save", action: {
                    viewModel.save()
                })
                .fontWeight(.semibold)
                .foregroundStyle(.tint)
            })
        })
    }
}

#Preview {
    ChangeDesignView(viewModel: ChangeDesignViewModel(navigationSender: PassthroughSubject<ResultEventFlow, Never>(), communicationBus: PassthroughSubject<ResultEventBus, Never>()))
}
