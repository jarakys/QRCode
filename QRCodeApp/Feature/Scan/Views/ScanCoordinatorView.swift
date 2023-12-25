//
//  ScanResultQRCodeCoordinatorView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import Foundation
import SwiftUI

struct ScanCoordinatorView: View {
    @StateObject public var viewModel: ScanCoordinatorViewModel
    @EnvironmentObject public var pathsState: PathState
    var body: some View {
        ScanView(viewModel: viewModel.scanViewModel)
            .navigationDestination(for: ScanFlow.self, destination: { flow in
                switch flow {
                case let .result(qrCodeString):
                    ScanResultQRCodeView(viewModel: viewModel.scanResultQRCodeViewModel(qrCodeString: qrCodeString))
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case let .result(qrCodeString):
                    pathsState.append(ScanFlow.result(qrCodeString: qrCodeString))
                    
                case .back:
                    pathsState.back()
                }
            })
    }
}
