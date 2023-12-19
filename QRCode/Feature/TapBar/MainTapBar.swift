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
                    Label("Scan", image: "scanIcon")
                }
            HistoryView()
                .tabItem {
                    Label("History", image: "historyIcon")
                }
            CreateCoordinatorView(viewModel: CreateCoordinatorViewModel())
            .tabItem {
                Label("Create", image: "createIcon")
            }
            SettingsView()
                .tabItem {
                    Label("Settings", image: "settingsIcon")
                }
        }
    }
}
