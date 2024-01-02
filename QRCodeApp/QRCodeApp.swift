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
    @State var startDidTap = UserDefaultsService.shared.get(key: .startDidTap, defaultValue: false)
    @State var tutorialPassed = UserDefaultsService.shared.get(key: .tutorialPassed, defaultValue: false)
    @State var closePremium = false
    var showIsPremium: Bool {
        false && closePremium
    }
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
            if startDidTap == false {
                StartView(viewModel: StartViewModel(didTap: {
                    UserDefaultsService.shared.set(key: .startDidTap, value: true)
                    withAnimation(.linear) {
                        startDidTap = true
                    }
                    
                }))
            } else if tutorialPassed == false {
                TutorialView(viewModel: TutorialViewModel(passedDidTap: {
                    UserDefaultsService.shared.set(key: .tutorialPassed, value: true)
                    withAnimation(.linear) {
                        tutorialPassed = true
                    }
                    
                }))
            } else if showIsPremium {
                Text("Premium screen")
            } else {
                MainTapBar()
                    .onAppear {
                        let standardAppearance = UITabBarAppearance()
                        standardAppearance.backgroundColor = UIColor(Color.gray)
                        standardAppearance.shadowColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
                        standardAppearance.backgroundColor = .white
                        UITabBar.appearance().barStyle = .default
                        UITabBar.appearance().barTintColor = .white
                        UITabBar.appearance().scrollEdgeAppearance = standardAppearance
                        UITabBar.appearance().standardAppearance = standardAppearance
                    }
            }
        }
    }
}
