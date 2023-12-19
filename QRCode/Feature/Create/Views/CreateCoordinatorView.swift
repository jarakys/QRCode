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
                    case .create:
                        Text("Create")
                    
                    case .result:
                        Text("Result")
                        
                    case .selection:
                        CreateView(viewModel: viewModel.selectionViewModel())
                        
                    case .premium:
                        Text("Premium")
                    }
                })
        })
    }
}
