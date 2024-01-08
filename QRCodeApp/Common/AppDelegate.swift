//
//  AppDelegate.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 28.12.2023.
//

import UIKit
import GoogleMobileAds
import RevenueCat
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        QRCodeContainer.document.design = .default()
        Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: "appl_dxIHeWavHKqQjizlInXWoZipnmp", appUserID: "app762340d612")
        _ = SubscriptionManager.shared
        KeychainManager.shared.keychain.clear()
        OpenAd.shared.requestAppOpenAd(completion: nil)
        return true
    }
}
