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
                case .changeDesign:
                    Text("Change design scree")
                    
                case let .editContent(items):
                    EditQRCodeContentView(viewModel: viewModel.editQRCodeContentViewModel(items: items))
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .back:
                    pathsState.back()
                    
                case .changeDesign:
                    pathsState.append(ResultFlow.changeDesign)
                    
                case let .editContent(items):
                    pathsState.append(ResultFlow.editContent(items: items))
                }
            })
    }
}
