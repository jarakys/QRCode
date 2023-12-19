//
//  CreateCoordinatorView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 19.12.2023.
//

import SwiftUI

struct CreateCoordinatorView: View {
    @StateObject public var viewModel: CreateCoordinatorViewModel
    var body: some View {
        NavigationStack(path: $viewModel.paths, root: {
            CreateView(viewModel: viewModel.selectionViewModel())
                .navigationDestination(for: CreateFlow.self, destination: { flow in
                    switch flow {
                    case let .create(type):
                        CreateContentLinkQRCodeView(viewModel: viewModel.createViewModel(type: type.type))
                    
                    case let .result(finalString):
                        Text(finalString)
                        
                    case .selection:
                        CreateView(viewModel: viewModel.selectionViewModel())
                        
                    case .premium:
                        Text("Premium")
                    }
                })
        })
    }
}
