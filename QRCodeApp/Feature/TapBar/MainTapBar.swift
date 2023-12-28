//
//  MainTapBar.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI

extension UITabBarController {
    var height: CGFloat {
        return self.tabBar.frame.size.height
    }
    
    var width: CGFloat {
        return self.tabBar.frame.size.width
    }
}


extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
    
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}


private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}


extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

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
        .overlay(
            // Custom TabBar indicator
            GeometryReader { geometry in
                let width = geometry.size.width / CGFloat(4) // Adjust based on the number of tabs
                let x = width * CGFloat(mainTapBarViewModel.tabSelection)
                let offset = (width - 50) / 2
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 50, height: 2) // Adjust the height of the indicator
                    .foregroundColor(.blue) // Adjust the color of the indicator
                    .offset(x: x + offset , y: geometry.size.height - UITabBarController().height) // Adjust the y offset based on the tab bar height
                    .animation(.spring()) // Add animation if desired
            }
        )
    }
}
