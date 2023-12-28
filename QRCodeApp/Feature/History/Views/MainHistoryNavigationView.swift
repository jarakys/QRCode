//
//  MainHistoryNavigationView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 26.12.2023.
//

import SwiftUI

struct MainHistoryNavigationView: View {
    @StateObject public var pathsState = PathState()
    
    var body: some View {
        NavigationStack(path: $pathsState.paths) {
            HistoryCoordinatorView(viewModel: HistoryCoordinatorViewModel())
                .environmentObject(pathsState)
                .configureNavigationBar {
                    $0.navigationBar.compactAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.standardAppearance = StyleConfig.mainNavBarAppearance
                    $0.navigationBar.scrollEdgeAppearance =  StyleConfig.mainNavBarAppearance
                }
        }
    }
}
