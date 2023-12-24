//
//  SettingsCoordinatorView.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import SwiftUI

struct SettingsCoordinatorView: View {
    @StateObject public var viewModel: SettingsCoordinatorViewModel
    @EnvironmentObject public var pathsState: PathState
    var body: some View {
        SettingsView(viewModel: viewModel.selectionViewModel)
    }
}
