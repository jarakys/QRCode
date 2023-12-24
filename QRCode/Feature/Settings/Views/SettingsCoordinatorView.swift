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
            .navigationDestination(for: SettingFlow.self, destination: { item in
                switch item {
                case .language:
                    SelectLanguageView(viewModel: viewModel.selectLanguageViewModel())
                
                case .settings:
                    SettingsView(viewModel: viewModel.selectionViewModel)
                }
            })
            .onReceive(viewModel.navigationSender, perform: { event in
                switch event {
                case .aboutUs:
                    pathsState.append(SettingFlow.language)
                    
                case .back:
                    pathsState.back()
                    
                case .language:
                    pathsState.append(SettingFlow.language)
                    
                case .privacy:
                    pathsState.append(SettingFlow.language)
                    
                case .terms:
                    pathsState.append(SettingFlow.language)
                }
            })
    }
}
