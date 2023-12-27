//
//  MainTapBar.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

struct MainTapBar: View {
    @StateObject public var mainTapBarViewModel = MainTapBarViewModel()
    var body: some View {
        TabView(selection: $mainTapBarViewModel.tabSelection) {
            MainScanNavigationView()
                .tabItem {
                    Label("Scan", image: "scanIcon")
                }
                .tag(0)
            MainHistoryNavigationView()
                .tabItem {
                    Label("History", image: "historyIcon")
                }
                .tag(1)
                .environmentObject(mainTapBarViewModel)
            MainCreateNavigationView()
                .tabItem {
                    Label("Create", image: "createIcon")
                }
                .tag(2)
            MainSettingsNavigationView()
                .tabItem {
                    Label("Settings", image: "settingsIcon")
                }
                .tag(3)
        }
    }
}
