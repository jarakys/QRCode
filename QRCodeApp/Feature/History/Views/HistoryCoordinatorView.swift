//
//  HistoryCoordinatorView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import SwiftUI

struct HistoryCoordinatorView: View {
    @StateObject public var viewModel: HistoryCoordinatorViewModel
    @EnvironmentObject public var pathsState: PathState
    @EnvironmentObject public var mainTapBarViewModel: MainTapBarViewModel
    
    var body: some View {
        HistoryView(viewModel: viewModel.historyViewModel)
            .navigationDestination(for: HistoryFlow.self, destination: { flow in
                switch flow {
                case let .details(model):
                    HistoryResultQRCodeView(viewModel: viewModel.historyResultQRCodeViewModel(model: model))
                    
                case let .editableDetails(model):
                    CreateResultQRCodeCoordinatorView(viewModel: viewModel.createResultQRCodeCoordinatorViewModel(model: model))
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .back:
                    pathsState.back()
                    
                case let .details(model):
                    pathsState.append(HistoryFlow.details(item: model))
                    
                case let .editableDetails(model):
                    pathsState.append(HistoryFlow.editableDetails(item: model))
                    
                case .create:
                    mainTapBarViewModel.tabSelection = 2
                    
                case .scans:
                    mainTapBarViewModel.tabSelection = 0
                }
            })
    }
}
