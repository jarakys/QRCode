//
//  AppDelegate.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        QRCodeContainer.document.design = .default()
        return true
    }
}
