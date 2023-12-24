//
//  MainSettingsNavigationView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct MainSettingsNavigationView: View {
    @StateObject public var pathsState = PathState()
    
    var body: some View {
        NavigationStack(path: $pathsState.paths) {
            SettingsCoordinatorView(viewModel: SettingsCoordinatorViewModel())
                .environmentObject(pathsState)
        }
    }
}
