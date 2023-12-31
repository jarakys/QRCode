//
//  SettingsView.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import Combine

struct SettingsView: View {
    @StateObject public var viewModel: SettingsViewModel
    
    var body: some View {
        List(viewModel.sections, id: \.type) { section in
            Section(content: {
                ForEach(section.items, id: \.hashValue) { item in
                    cellFabic(item: item)
                }
            }, header: {
                if section.type == viewModel.firstSection?.type {
                    Text(section.title)
                        .padding(.top, 16)
                        .padding(.bottom, 4)
                } else {
                    Text(section.title)
                }
            })
            .listRowInsets(EdgeInsets())
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.automatic)
        .onReceive(viewModel.eventSender, perform: { event in
            guard event == .languageDidTap else { return }
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(settingsURL) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        })
        .onAppear {
            viewModel.reconfigureOnAppear()
        }
        .fullScreenCover(isPresented: $viewModel.showPremium, content: {
            PaywallView(shouldStartSession: false, shouldRequestAd: false)
        })
    }
    
    @ViewBuilder
    private func cellFabic(item: SettingsItemType) -> some View {
        switch item {
        case let .inApp(settingsItemSubtitleModel):
            InAppCellView(image: settingsItemSubtitleModel.icon,
                          title: settingsItemSubtitleModel.title,
                          subtitle: settingsItemSubtitleModel.subtitle)
            .cornerRadius(10)
            .onTapGesture {
                viewModel.showPremiumDidTap()
            }
            
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
            .onTapGesture {
                viewModel.languageDidTap()
            }
            
        case let .aboutUs(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://qrscanread.com")!)
                }
            
        case let .termsAndConditions(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://qrscanread.com/terms.html")!)
                }
            
        case let .privacyPolicy(settingsItemModel):
            SettingsCellView(model: settingsItemModel)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://qrscanread.com/privacy.html")!)
                }
            
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(navigationSender: PassthroughSubject<SettingsEventFlow, Never>(), communicationBus: PassthroughSubject<SettingsEventBus, Never>()))
}
