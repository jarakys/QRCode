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
                .shadow(color: Color(red: 0, green: 0.3294, blue: 0.4902, opacity: 0.1016),
                                    radius: 9.656891822814941,
                                    x: 3.218963861465454,
                                    y: 3.218963861465454)
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
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.tint)
                    
            })
            ToolbarItem(placement: .principal, content: {
                Text("Templates")
                    .font(.system(size: 17, weight: .semibold))
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button("Next", action: {
                    viewModel.save()
                })
                .fontWeight(.semibold)
                .foregroundStyle(.tint)
            })
        })
    }
}

#Preview {
    ChangeDesignView(viewModel: ChangeDesignViewModel(qrCodeString: "Hello", navigationSender: PassthroughSubject<ResultEventFlow, Never>(), communicationBus: PassthroughSubject<ResultEventBus, Never>()))
}
