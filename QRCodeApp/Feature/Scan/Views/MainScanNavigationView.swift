//
//  MainScanNavigationView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 25.12.2023.
//

import SwiftUI

struct MainScanNavigationView: View {
    @StateObject public var pathsState = PathState()
    var body: some View {
        NavigationStack(path: $pathsState.paths) {
            ScanCoordinatorView(viewModel: ScanCoordinatorViewModel())
                .environmentObject(pathsState)
        }
    }
}
