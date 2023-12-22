//
//  EditQRCodeContentView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct EditQRCodeContentView: View {
    @StateObject public var viewModel: EditQRCodeContentViewModel
    
    var body: some View {
        ScrollView {
                TextFieldForm(items: viewModel.items)
                    .scrollDismissesKeyboard(.interactively)
                    .padding(.all, 16)
        }
        .background(.secondaryBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading, content: {
                Button("Cancel", action: {
                    viewModel.cancel()
                })
                .foregroundStyle(.tint)
                    
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
