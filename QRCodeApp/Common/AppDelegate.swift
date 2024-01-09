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
        Purchases.configure(withAPIKey: "appl_dxIHeWavHKqQjizlInXWoZipnmp")
//            Purchases.configure(withAPIKey: "appl_dxIHeWavHKqQjizlInXWoZipnmp", appUserID: "app762340d612")
        _ = SubscriptionManager.shared
        Purchases.shared.delegate = self
        OpenAd.shared.requestAppOpenAd(completion: nil)
        return true
    }
    
    
}

extension AppDelegate: PurchasesDelegate {
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        SubscriptionManager.shared.isPremium = !customerInfo.entitlements.activeInCurrentEnvironment.isEmpty
        print("[test] \(customerInfo.entitlements.active.mapValues({ $0.isActive }))")
        // handle any changes to customerInfo
    }
}
