//
//  CreateCoordinatorView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI

struct CreateCoordinatorView: View {
    @StateObject public var viewModel: CreateCoordinatorViewModel
    @EnvironmentObject public var pathsState: PathState
    
    var body: some View {
        CreateView(viewModel: viewModel.selectionViewModel)
            .navigationDestination(for: CreateFlow.self, destination: { flow in
                switch flow {
                case let .create(type):
                    CreateContentLinkQRCodeView(viewModel: viewModel.createViewModel(type: type.type))
                    
                case let .result(finalString, qrCodeFormat):
                    CreateResultQRCodeCoordinatorView(viewModel: viewModel.createResultQRCodeCoordinatorViewModel(qrCodeFormat: qrCodeFormat, qrCodeString: finalString))
                        .environmentObject(pathsState)
                    
                case .selection:
                    CreateView(viewModel: viewModel.selectionViewModel)
                    
                case .premium:
                    Text("Premium")
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .back:
                    pathsState.back()
                    
                case .popToRoot:
                    pathsState.popToRoot()
                    
                case .premium:
                    pathsState.append(CreateFlow.premium)
                    
                case let .result(finalString, type):
                    pathsState.append(CreateFlow.result(finalString: finalString, type: type))
                    
                case let .create(type):
                    pathsState.append(CreateFlow.create(type: type))
                    
                case .selection:
                    pathsState.append(CreateFlow.selection)
                }
            })
    }
}
