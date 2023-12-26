//
//  HistoryView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import Combine

struct HistoryView: View {
    @StateObject public var viewModel: HistoryViewModel
    var body: some View {
        VStack {
            Picker("", selection: $viewModel.selectedType) {
                Text(HistorySegmentType.scanned.description)
                    .tag(0)
                Text(HistorySegmentType.created.description)
                    .tag(1)
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.secondaryBackground)
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(navigationSender: PassthroughSubject<HistoryEventFlow, Never>()))
}
