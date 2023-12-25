//
//  SelectLanguageView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI
import Combine

struct SelectLanguageView: View {
    @StateObject public var viewModel: SelectLanguageViewModel
    
    var body: some View {
        List(viewModel.items, id:\.item.hashValue) { item in
            LanguageCellView(model: item)
                .background(.white.opacity(0.1))
                .onTapGesture {
                    viewModel.didClick(on: item)
                }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SelectLanguageView(viewModel: SelectLanguageViewModel(communicationBus: PassthroughSubject<SettingsEventBus, Never>()))
}
