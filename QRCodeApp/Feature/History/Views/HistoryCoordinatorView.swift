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
                case .details:
                    Text("Details")
                    
                case .editableDetails:
                    Text("Editable details")
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .back:
                    pathsState.back()
                    
                case .details:
                    pathsState.append(HistoryFlow.details)
                    
                case .editableDetails:
                    pathsState.append(HistoryFlow.editableDetails)
                    
                case .create:
                    mainTapBarViewModel.tabSelection = 2
                    
                case .scans:
                    mainTapBarViewModel.tabSelection = 0
                }
            })
    }
}
