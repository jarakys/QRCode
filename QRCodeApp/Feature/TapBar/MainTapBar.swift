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
            MainScanNavigationView()
                .tabItem {
                    Label("Scan", image: "scanIcon")
                }
            MainHistoryNavigationView()
                .tabItem {
                    Label("History", image: "historyIcon")
                }
            MainCreateNavigationView()
                .tabItem {
                    Label("Create", image: "createIcon")
                }
            MainSettingsNavigationView()
                .tabItem {
                    Label("Settings", image: "settingsIcon")
                }
        }
    }
}
