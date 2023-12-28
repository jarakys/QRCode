//
//  CreateResultQRCodeCoordinatorView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct CreateResultQRCodeCoordinatorView: View {
    @StateObject public var viewModel: CreateResultQRCodeCoordinatorViewModel
    @EnvironmentObject public var pathsState: PathState
    var body: some View {
        CreateResultQRCodeView(viewModel: viewModel.createResultQRCodeViewModel)
            .navigationDestination(for: ResultFlow.self, destination: { flow in
                switch flow {
                case let .changeDesign(qrCodeString):
                    ChangeDesignView(viewModel: viewModel.changeDesignViewViewModel(qrCodeString: qrCodeString))
                    
                case let .editContent(items):
                    EditQRCodeContentView(viewModel: viewModel.editQRCodeContentViewModel(items: items))
                    
                case let .detailedChangeDesing(qrCodeString, qrCodeDesign):
                    DetailedChangeDesignView(viewModel: viewModel.detailedChangeDesignViewModel(qrCodeString: qrCodeString, qrCodeDesign: qrCodeDesign))
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .back:
                    pathsState.back()
                    
                case let .changeDesign(qrCodeString):
                    pathsState.append(ResultFlow.changeDesign(qrCodeString: qrCodeString))
                    
                case let .editContent(items):
                    pathsState.append(ResultFlow.editContent(items: items))
                    
                case let .detailedChangeDesign(qrCodeString, qrCodeDesign):
                    pathsState.append(ResultFlow.detailedChangeDesing(qrCodeString: qrCodeString, qrCodeDesign: qrCodeDesign))
                    
                case .backToRoot:
                    pathsState.paths.removeLast(2)
                    
                case .backToMain:
                    pathsState.popToRoot()
                }
            })
    }
}
