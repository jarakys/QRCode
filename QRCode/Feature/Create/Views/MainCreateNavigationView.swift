//
//  MainCreateNavigationView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 22.12.2023.
//

import SwiftUI

struct MainCreateNavigationView: View {
    @StateObject public var pathsState = PathState()
    var body: some View {
        NavigationStack(path: $pathsState.paths) {
            CreateCoordinatorView(viewModel: CreateCoordinatorViewModel())
                .environmentObject(pathsState)
        }
    }
}
