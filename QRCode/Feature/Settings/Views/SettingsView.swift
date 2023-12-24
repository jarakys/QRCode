//
//  SettingsView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject public var viewModel: SettingsViewModel
    
    var body: some View {
        List(viewModel.sections, id: \.type) { section in
            Section(section.title, content: {
                ForEach(section.items, id: \.hashValue) { item in
                    cellFabic(item: item)
                }
            })
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.automatic)
        .toolbarBackground(.blue, for: .navigationBar)
    }
    
    @ViewBuilder
    private func cellFabic(item: SettingsItemType) -> some View {
        switch item {
        case let .inApp(settingsItemSubtitleModel):
            InAppCellView(image: settingsItemSubtitleModel.icon,
                          title: settingsItemSubtitleModel.title,
                          subtitle: settingsItemSubtitleModel.subtitle)
            .cornerRadius(10)
            
        case let .license(settingsItemValueModel):
            SettingsValueStringCellView(icon: settingsItemValueModel.icon,
                                        title: settingsItemValueModel.title,
                                        value: settingsItemValueModel.value)
            
        case let .qrScans(settingsItemValueModel):
            SettingsValueStringCellView(icon: settingsItemValueModel.icon,
                                        title: settingsItemValueModel.title,
                                        value: settingsItemValueModel.value)
            
        case let .qrCreation(settingsItemValueModel):
            SettingsValueStringCellView(icon: settingsItemValueModel.icon,
                                        title: settingsItemValueModel.title,
                                        value: settingsItemValueModel.value)
        case let .vibrate(settingsItemValueSubtitleModel):
            SettingsValueBoolCellView(model: settingsItemValueSubtitleModel)
            
        case let .beep(settingsItemValueSubtitleModel):
            SettingsValueBoolCellView(model: settingsItemValueSubtitleModel)
            
        case let .language(settingsItemValueModel):
            SettingsValueStringCellView(icon: settingsItemValueModel.icon,
                                        title: settingsItemValueModel.title,
                                        value: settingsItemValueModel.value)
            
        case let .aboutUs(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
            
        case let .termsAndConditions(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
            
        case let .privacyPolicy(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
            
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
