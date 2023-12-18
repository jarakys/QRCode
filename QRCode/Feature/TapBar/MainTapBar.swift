//
//  MainTapBar.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct MainTapBar: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", image: ImageResource.scanIcon)
                }
            HistoryView()
                .tabItem {
                    Label("History", image: ImageResource.historyIcon)
                }
            NavigationView {
                CreateView(viewModel: CreateViewModel())
            }
            .tabItem {
                Label("Create", image: ImageResource.createIcon)
            }
            SettingsView()
                .tabItem {
                    Label("Settings", image: ImageResource.settingsIcon)
                }
        }
    }
}
