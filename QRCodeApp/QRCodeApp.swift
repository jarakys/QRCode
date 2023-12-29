//
//  QRCodeApp.swift
//  QRCode
//
//  Created by Kyrylo Chernov on 18.12.2023.
//

import SwiftUI
import SwiftData

import QRCode

@main
struct QRCodeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let standardAppearance = UITabBarAppearance()
                    standardAppearance.backgroundColor = UIColor(Color.gray)
                    standardAppearance.shadowColor = UIColor(Color.black)
                    standardAppearance.backgroundColor = .white
                    UITabBar.appearance().barStyle = .default
                    UITabBar.appearance().barTintColor = .white
                    UITabBar.appearance().scrollEdgeAppearance = standardAppearance
                    UITabBar.appearance().standardAppearance = standardAppearance
                }
        }
    }
}
