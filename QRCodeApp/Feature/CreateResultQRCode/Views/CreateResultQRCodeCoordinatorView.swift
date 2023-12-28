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
                    DetailedChangeDesignView(viewModel: DetailedChangeDesignViewModel(qrCodeString: qrCodeString, qrCodeDesign: qrCodeDesign, navigationSender: viewModel.navigationSender, communicationBus: .init()))
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
                    
                case .backToMain:
                    pathsState.popToRoot()
                }
            })
    }
}
