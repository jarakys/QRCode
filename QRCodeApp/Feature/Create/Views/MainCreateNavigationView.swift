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
                .configureNavigationBar {
                    $0.navigationBar.compactAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.standardAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.scrollEdgeAppearance =  StyleConfig.mainNavBarAppearance
                }
        }
    }
}
